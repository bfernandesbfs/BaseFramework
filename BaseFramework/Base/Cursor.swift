//
//  Cursor.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 05/11/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation


public struct Cursor {
    
    private let handle: COpaquePointer
    private let columnCount: Int
    
    public init(_ statement: Statement) {
        handle = statement.handle
        columnCount = statement.columnCount
    }
    
    
    public subscript(idx: Int) -> Int64 {
        return sqlite3_column_int64(handle, Int32(idx))
    }
    
    public subscript(idx: Int) -> Int {
        return Int.fromDatatypeValue(self[idx])
    }
    
    public subscript(idx: Int) -> String {
        return String.fromCString(UnsafePointer(sqlite3_column_text(handle, Int32(idx)))) ?? ""
    }
    
    public subscript(idx: Int) -> Double {
        return sqlite3_column_double(handle, Int32(idx))
    }
    
    public subscript(idx: Int) -> Bool {
        return Bool.fromDatatypeValue(self[idx])
    }
    
    public subscript(idx: Int) -> NSData {
        let bytes = sqlite3_column_blob(handle, Int32(idx))
        let length = Int(sqlite3_column_bytes(handle, Int32(idx)))
        return NSData(bytes: bytes, length: length)
    }
    
}

extension Cursor : SequenceType {
    
    public subscript(idx: Int) -> Value? {
        
        let columnType = sqlite3_column_type(handle, Int32(idx))
        
        switch columnType {
        case SQLITE_BLOB:
            return self[idx] as NSData
        case SQLITE_FLOAT:
            return self[idx] as Double
        case SQLITE_INTEGER:
            return self[idx] as Int64
        case SQLITE_NULL:
            return nil
        case SQLITE_TEXT:
            return self[idx] as String
        case let type:
            fatalError("unsupported column type: \(type)")
        }
    }
    
    public func generate() -> AnyGenerator<Value?> {
        var idx = 0
        return anyGenerator {
            idx >= self.columnCount ? Optional<Value?>.None : self[idx++]
        }
    }
    
}


public struct Row {
    
    private let columnNames: [String: Int]
    
    private let values: [Value?]

    public init(_ columnNames: [String: Int], _ values: [Value?]) {
        self.columnNames = columnNames
        self.values = values
    }
    
    public subscript(column: String) -> Value! {
        return get(column)!
    }
    
    private func get(column: String) -> Value? {
        
        func valueAtIndex(idx: Int) -> Value? {
            guard let value = values[idx] else { return nil }
            return value
        }
        
        guard let idx = columnNames[column] else {
            let similar = Array(columnNames.keys).filter { $0.hasSuffix(".\(column)") }
            
            switch similar.count {
            case 0:
                fatalError("no such column '\(column)' in columns: \(columnNames.keys.sort())")
            case 1:
                return valueAtIndex(columnNames[similar[0]]!)
            default:
                fatalError("ambiguous column '\(column)' (please disambiguate: \(similar))")
            }
        }
        
        return valueAtIndex(idx)
    }
}


