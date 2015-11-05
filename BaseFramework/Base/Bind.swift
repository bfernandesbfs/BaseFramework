//
//  Bind.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 03/11/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation

public protocol Binding {}

public protocol Number : Binding {}

public protocol Value   {
    
    typealias ValueType = Self
    
    typealias Datatype : Binding
    
    static var declaredDatatype: String { get }
    
    static func fromDatatypeValue(datatypeValue: Datatype) -> ValueType
    
    var datatypeValue: Datatype { get }
    
}

public protocol BindValue {
    
    static var declaredDatatype: String { get }
    
     var datatypeValue: String  { get }
    
}

extension Double : Number, Value {
    
    public static let declaredDatatype = "REAL"
    
    public static func fromDatatypeValue(datatypeValue: Double) -> Double {
        return datatypeValue
    }
    
    public var datatypeValue: Double {
        return self
    }
    
}

extension Int64 : Number, Value {
    
    public static let declaredDatatype = "INTEGER"
    
    public static func fromDatatypeValue(datatypeValue: Int64) -> Int64 {
        return datatypeValue
    }
    
    public var datatypeValue: Int64 {
        return self
    }
    
}

extension String : Binding, Value {
    
    public static let declaredDatatype = "TEXT"
    
    public static func fromDatatypeValue(datatypeValue: String) -> String {
        return datatypeValue
    }
    
    public var datatypeValue: String {
        return self
    }
    
}

extension NSDate {
    public var datatypeValue: String {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return "\(df.stringFromDate(self))"
    }
}


// MARK: -

extension Bool : Binding, Value {
    
    public static var declaredDatatype = Int.declaredDatatype
    
    public static func fromDatatypeValue(datatypeValue: Int) -> Bool {
        return datatypeValue != 0
    }
    
    public var datatypeValue: Int {
        return self ? 1 : 0
    }
    
}

extension Int : Number, Value {
    
    public static var declaredDatatype = Int64.declaredDatatype
    
    public static func fromDatatypeValue(datatypeValue: Int64) -> Int {
        return Int(datatypeValue)
    }
    
    public var datatypeValue: Int64 {
        return Int64(self)
    }
    
}

