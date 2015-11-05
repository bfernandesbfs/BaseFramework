//
//  Bind.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 03/11/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation

public protocol Value {}

public protocol Binding {
    typealias ValueType = Self
    typealias Datatype : Value
    static var declaredDatatype: String { get }
    static func fromDatatypeValue(datatypeValue: Datatype) -> ValueType
    
}

extension String : Value , Binding {
    
    public static let declaredDatatype = "TEXT"
    public static func fromDatatypeValue(datatypeValue: String) -> String {
        return datatypeValue
    }
}

extension Int : Value , Binding  {
    
    public static var declaredDatatype = Int64.declaredDatatype
    public static func fromDatatypeValue(datatypeValue: Int64) -> Int {
        return Int(datatypeValue)
    }
    public func toInt64() -> Int64 {
        return Int64(self)
    }
}

extension Int64 : Value , Binding  {
    
    public static let declaredDatatype = "INTEGER"
    public static func fromDatatypeValue(datatypeValue: Int64) -> Int64 {
        return datatypeValue
    }
}

extension Double : Value , Binding  {
    
    public static let declaredDatatype = "DOUBLE"
    public static func fromDatatypeValue(datatypeValue: Double) -> Double {
        return datatypeValue
    }
}

extension Float : Value , Binding   {
    
    public static let declaredDatatype = "FLOAT"
    public static func fromDatatypeValue(datatypeValue: Float) -> Float {
        return datatypeValue
    }
}

extension NSNumber : Value , Binding  {
    
    public class var declaredDatatype:String {
        return "NUMERIC"
    }
    public static func fromDatatypeValue(datatypeValue: NSNumber) -> NSNumber {
        return datatypeValue
    }
}

extension Bool : Value , Binding  {
    
    public static var declaredDatatype = "BOOLEAN"
    public static func fromDatatypeValue(datatypeValue: Int) -> Bool {
        return datatypeValue != 0
    }
    
    public func toInt() -> Int {
        return self ? 1 : 0
    }
    
}

extension NSDate : Value , Binding  {
    
    public class var declaredDatatype:String {
        return "DATETIME"
    }
    public class func fromDatatypeValue(datatypeValue: NSDate) -> NSDate {
        return dateFormatter.dateFromString(datatypeValue.toString())!
    }

    public func toString() -> String {
        return dateFormatter.stringFromDate(self)
    }
}

extension NSData : Value , Binding  {
    
    public class var declaredDatatype:String {
        return "BLOB"
    }
    public class func fromDatatypeValue(datatypeValue: NSData) -> NSData {
        return datatypeValue
    }

}

