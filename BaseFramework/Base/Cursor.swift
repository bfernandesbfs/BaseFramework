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
    
    public subscript(idx: Int) -> Double {
        return sqlite3_column_double(handle, Int32(idx))
    }
    
    public subscript(idx: Int) -> Int64 {
        return sqlite3_column_int64(handle, Int32(idx))
    }
    
    public subscript(idx: Int) -> String {
        return String.fromCString(UnsafePointer(sqlite3_column_text(handle, Int32(idx)))) ?? ""
    }
    
    public subscript(idx: Int) -> NSData {
        let bytes = sqlite3_column_blob(handle, Int32(idx))
        let length = Int(sqlite3_column_bytes(handle, Int32(idx)))
        return NSData(bytes: bytes, length: length)
    }
    
    // MARK: -
    
    public subscript(idx: Int) -> Bool {
        return Bool.fromDatatypeValue(self[idx])
    }
    
    public subscript(idx: Int) -> Int {
        return Int.fromDatatypeValue(self[idx])
    }
}


public struct Row {
    
    private let columnNames: [String: Int]
    
    private let values: [AnyObject?]

    public init(_ columnNames: [String: Int], _ values: [AnyObject?]) {
        self.columnNames = columnNames
        self.values = values
    }
    
//    public func get<V: Value>(column: Expression<V?>) -> V? {
//        func valueAtIndex(idx: Int) -> V? {
//            guard let value = values[idx] as? V.Datatype else { return nil }
//            return (V.fromDatatypeValue(value) as? V)!
//        }
//        
//        guard let idx = columnNames[column.template] else {
//            let similar = Array(columnNames.keys).filter { $0.hasSuffix(".\(column.template)") }
//            
//            switch similar.count {
//            case 0:
//                fatalError("no such column '\(column.template)' in columns: \(columnNames.keys.sort())")
//            case 1:
//                return valueAtIndex(columnNames[similar[0]]!)
//            default:
//                fatalError("ambiguous column '\(column.template)' (please disambiguate: \(similar))")
//            }
//        }
//        
//        return valueAtIndex(idx)
//    }
    
}

extension Cursor : SequenceType {
    
    public func generate() -> AnyGenerator<AnyObject?> {
        var idx = 0
        return anyGenerator {
            if idx >= self.columnCount {
                return self[idx++]
            }
            return nil
        }
    }
    
}
