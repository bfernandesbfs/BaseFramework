//
//  BaseObjectStore.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 29/10/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation

public protocol SubObject {
    
    static func objClassName() -> String
    static func registerClass()
    
}

public class BaseObjectStore {
    
    private var clzz:AnyObject!
    private var className:String!
    private var properties:[AnyObject]!
    
    private var db:Connection!
    
    public var debugDescription:String {
        return properties.description
    }
    
    init(kls:AnyObject) {
        
        db = try! Connection(createPath())
        
        if let obj = kls.dynamicType as? SubObject.Type {
            clzz = kls
            className = obj.objClassName()
            properties = refectObject(clzz)

        } else {
            assertionFailure("Can only call 'Generic Object' on subclasses conforming to SubObject")
        }
    }
    
    init(kls:NSObject.Type) {
        
        db = try! Connection(createPath())
        
        if let obj = kls as? SubObject.Type {
            clzz = kls.init()
            className = obj.objClassName()
            properties = refectObject(clzz)
        } else {
            assertionFailure("Can only call 'Generic Object' on subclasses conforming to SubObject")
        }
    }
    
    private enum SchemaType {
        
        case Create(String,[AnyObject])
        case Drop(String)
        case Select(String)
        case Replace(String,[AnyObject])
        case Insert(String,[AnyObject])
        case Delete(String,Int64)
    
        var sql: String {
            switch self {
            case .Create(let className,let properties):
                return "CREATE TABLE IF NOT EXISTS \(className) (objectId INTEGER PRIMARY KEY AUTOINCREMENT \(createSql(properties)))"
            case .Drop(let className):
                return "DROP TABLE \(className)"
            case .Select(let className):
                return "SELECT * FROM \(className) WHERE objectId = ?"
            case .Replace(let className,let properties):
                return "INSERT OR REPLACE INTO \(className) (\(saveSql(properties)))"
            case .Insert(let className,let properties):
                return "INSERT INTO \(className) (\(saveSql(properties)))"
            case .Delete(let className , let objectId):
                let comp = objectId == 0 ? "" : " WHERE objectId = ?"
                return "DELETE FROM \(className)" + comp
            }
        }
        
        var args:[AnyObject?] {
            switch self {
            case .Replace(_,let properties):
                return getArgs(properties)
            case .Insert(_,let properties):
                return getArgs(properties)
            default:
                return []
            }
        }
        
        private func createSql(properties:[AnyObject]) -> String {
            var fields:String = String()
            for property in properties {
                fields += ", \(property["key"] as! String) \(property["type"] as! String)"
            }
            return fields
        }
        
        private func saveSql(properties:[AnyObject]) -> String {
            
            var fields:String = ""
            var values:String = "VALUES ( "
            var isFirst = true
            
            switch self {
            case .Replace(_, _):
                fields = "objectId "
                values += ",? "
                break
            default:
                break
            }
            
            for property in properties {
                
                if isFirst {
                    isFirst = false
                    fields += "\(property["key"] as! String)"
                    values += "?"
                    
                } else {
                    fields += ", \(property["key"] as! String)"
                    values += ", ?"
                }

            }
            return fields + ") \(values)"
        }
        
        private func getArgs(properties:[AnyObject]) -> [AnyObject?] {
            
            var list:[AnyObject?] = [AnyObject]()
            for property in properties {
                if let obj:AnyObject = property["value"] {
                    list.append(obj)
                }
                else{
                    list.append(nil)
                }
            }
            return list
        }
    }
    
    
    public func registerSubClass(){
        
        if properties.count > 0 {
            let scheme = SchemaType.Create(className,properties)
            print(scheme.sql)
            
            do {
                try db.execute(scheme.sql)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    public func unRegisterSubClass(){
        let scheme = SchemaType.Drop(className)
        do {
            try db.execute(scheme.sql)
        }
        catch let error {
            print(error)
        }
    }
    
    public func saveObject(){
        properties = refectObject(clzz)
        if properties.count > 0 {
            do {
                let base = clzz as! BaseObject
                let schema = SchemaType.Insert(className,properties)
                let rowId = try db.runRowId(schema.sql, schema.args)
                base.objectId = NSNumber(longLong: rowId).integerValue
            }
            catch let error {
                print(error)
            }
            
        }
    }
    
    public func changeObject(){
        if properties.count > 0 {
            let scheme = SchemaType.Replace(className,properties)
            print(scheme.sql)
        }
    }
    
    public func removeObject() -> Int {
        var changes:Int = 0
        
        if let objectId = (clzz as! BaseObject).objectId {
            let scheme = SchemaType.Delete(className, objectId.datatypeValue)
            do {
                changes = try db.runChange(scheme.sql, objectId)
            }
            catch let error {
                print(error)
            }
        
        }
        
        return changes
    }
    
    public func removeAllObject() -> Int{
        var changes:Int = 0
        
        let scheme = SchemaType.Delete(className , 0)
        do {
            changes = try db.runChange(scheme.sql)
        }
        catch let error {
            print(error)
        }
        
        return changes
    }
    

    
    private func refectObject(kls:AnyObject) -> [AnyObject] {
        
        let aMirror = Mirror(reflecting: kls)
        var properties = [AnyObject]()
        
        for case let (label?, anyValue) in aMirror.children {
            if let type = reflectType(Mirror(reflecting: anyValue).subjectType) {
                if let value = anyValue as? AnyObject {
                    properties.append(["key":label,"value":value, "type":type])
                }
                else{
                    properties.append(["key":label, "type":type])
                }
            }
            else{
                assertionFailure("This property '\(label)' not is supported for BaseObject")
            }
        }
        
        
        
        return properties
    }
    
    private func reflectType(type:Any) -> String! {
        
        switch type {
        case is String.Type, is Optional<String>.Type, is NSString.Type, is Optional<NSString>.Type:
            return "TEXT"
        case is Int.Type, is Optional<Int>.Type,is NSInteger.Type:
            return "INTEGER"
        case is Double.Type, is Optional<Double>.Type:
            return "DOUBLE"
        case is Float.Type, is Optional<Float>.Type:
            return "FLOAT"
        case is NSNumber.Type, is Optional<NSNumber>.Type:
            return "NUMERIC"
        case is Bool.Type, is Optional<Bool>.Type:
            return "BOOLEAN"
        case is NSDate.Type, is Optional<NSDate>.Type:
            return "DATETIME"
        case is NSData.Type, is Optional<NSData>.Type:
            return "BLOB"
        default:
            return nil
        }
        
    }
    
    private func createPath() -> String {
        
        let docsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        let databaseStr = "BaseS.db"
        let dbPath = docsPath.stringByAppendingPathComponent(databaseStr)
        
        print(dbPath)
        
        return dbPath as String
    }

    
}

