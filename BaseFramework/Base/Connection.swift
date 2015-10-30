//
//  Connection.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 29/10/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation

/// A connection to SQLite.
public final class Connection {

    /// The location of a SQLite database.
    public enum Location {
        case InMemory
        case Temporary
        case URI(String)
    }

    public var handle: COpaquePointer { return _handle }

    private var _handle: COpaquePointer = nil
    
    private var queue = dispatch_queue_create("br.com.bfs.BaseFramework", DISPATCH_QUEUE_SERIAL)
    
    private static let queueKey = unsafeBitCast(Connection.self, UnsafePointer<Void>.self)
    
    private lazy var queueContext: UnsafeMutablePointer<Void> = unsafeBitCast(self, UnsafeMutablePointer<Void>.self)

    /// Initializes a new SQLite connection.
    ///
    /// - Parameters:
    ///
    ///   - location: The location of the database. Creates a new database if it
    ///     doesn’t already exist (unless in read-only mode).
    ///
    ///     Default: `.InMemory`.
    ///
    ///   - readonly: Whether or not to open the database in a read-only state.
    ///
    ///     Default: `false`.
    ///
    /// - Returns: A new database connection.
    public init(_ location: Location = .InMemory, readonly: Bool = false) throws {
        let flags = readonly ? SQLITE_OPEN_READONLY : SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
        try check(sqlite3_open_v2(location.description, &_handle, flags | SQLITE_OPEN_FULLMUTEX, nil))
        dispatch_queue_set_specific(queue, Connection.queueKey, queueContext, nil)
    }

    /// Initializes a new connection to a database.
    ///
    /// - Parameters:
    ///
    ///   - filename: The location of the database. Creates a new database if
    ///     it doesn’t already exist (unless in read-only mode).
    ///
    ///   - readonly: Whether or not to open the database in a read-only state.
    ///
    ///     Default: `false`.
    ///
    /// - Throws: `Result.Error` if a connection cannot be established.
    ///
    /// - Returns: A new database connection.
    public convenience init(_ filename: String, readonly: Bool = false) throws {
        try self.init(.URI(filename), readonly: readonly)
    }

    deinit {
        sqlite3_close(handle)
    }

    // MARK: -

    /// Whether or not the database was opened in a read-only state.
    public var readonly: Bool {
        return sqlite3_db_readonly(handle, nil) == 1
    }

    /// The last rowid inserted into the database via this connection.
    public var lastInsertRowid: Int64? {
        let rowid = sqlite3_last_insert_rowid(handle)
        return rowid > 0 ? rowid : nil
    }

    /// The last number of changes (inserts, updates, or deletes) made to the
    /// database via this connection.
    public var changes: Int {
        return Int(sqlite3_changes(handle))
    }

    /// The total number of changes (inserts, updates, or deletes) made to the
    /// database via this connection.
    public var totalChanges: Int {
        return Int(sqlite3_total_changes(handle))
    }

    // MARK: - Execute

    /// Executes a batch of SQL statements.
    ///
    /// - Parameter SQL: A batch of zero or more semicolon-separated SQL
    ///   statements.
    ///
    /// - Throws: `Result.Error` if query execution fails.
    public func execute(SQL: String) throws {
        try sync { try self.check(sqlite3_exec(self.handle, SQL, nil, nil, nil)) }
    }

    // MARK: - Error Handling

    func sync<T>(block: () throws -> T) rethrows -> T {
        var success: T?
        var failure: ErrorType?

        let box: () -> Void = {
            do {
                success = try block()
            } catch {
                failure = error
            }
        }

        if dispatch_get_specific(Connection.queueKey) == queueContext {
            box()
        } else {
            dispatch_sync(queue, box)
        }

        if let failure = failure {
            try { () -> Void in throw failure }()
        }

        return success!
    }

    func check(resultCode: Int32, statement: Statement? = nil) throws -> Int32 {
        guard let error = Result(errorCode: resultCode, connection: self, statement: statement) else {
            return resultCode
        }

        throw error
    }

}

extension Connection : CustomStringConvertible {

    public var description: String {
        return String.fromCString(sqlite3_db_filename(handle, nil))!
    }

}

extension Connection.Location : CustomStringConvertible {

    public var description: String {
        switch self {
        case .InMemory:
            return ":memory:"
        case .Temporary:
            return ""
        case .URI(let URI):
            return URI
        }
    }

}

public enum Result : ErrorType {

    private static let successCodes: Set = [SQLITE_OK, SQLITE_ROW, SQLITE_DONE]

    case Error(message: String, code: Int32, statement: Statement?)

    init?(errorCode: Int32, connection: Connection, statement: Statement? = nil) {
        guard !Result.successCodes.contains(errorCode) else { return nil }

        let message = String.fromCString(sqlite3_errmsg(connection.handle))!
        self = Error(message: message, code: errorCode, statement: statement)
    }

}

extension Result : CustomStringConvertible {

    public var description: String {
        switch self {
        case let .Error(message, _, statement):
            guard let statement = statement else { return message }

            return "\(message) (\(statement))"
        }
    }

}
