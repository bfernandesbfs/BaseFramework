//
//  Statement.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 29/10/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

/// A single SQL statement.
public final class Statement {

    private var handle: COpaquePointer = nil

    private let connection: Connection

    init(_ connection: Connection, _ SQL: String) {
        self.connection = connection
        try! connection.check(sqlite3_prepare_v2(connection.handle, SQL, -1, &handle, nil))
    }

    deinit {
        sqlite3_finalize(handle)
    }

    public lazy var columnCount: Int = Int(sqlite3_column_count(self.handle))

    public lazy var columnNames: [String] = (0..<Int32(self.columnCount)).map {
        String.fromCString(sqlite3_column_name(self.handle, $0))!
    }

    public func step() throws -> Bool {
        return try connection.sync { try self.connection.check(sqlite3_step(self.handle)) == SQLITE_ROW }
    }

    private func reset(clearBindings shouldClear: Bool = true) {
        sqlite3_reset(handle)
        if (shouldClear) { sqlite3_clear_bindings(handle) }
    }

}


extension Statement : CustomStringConvertible {

    public var description: String {
        return String.fromCString(sqlite3_sql(handle))!
    }

}

