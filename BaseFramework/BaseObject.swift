//
//  BaseObject.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 29/10/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation

public class BaseObject : NSObject {
    
    private var store:BaseObjectService!

    public var objectId:Int!
    
    public var className:String!
    
    override public var description:String {
        return store.debugDescription
    }
    
    override public init() {
        super.init()
        
        store = BaseObjectService(kls: self)
        className = store.className
    }
    
    public init(className:String){
        
        self.className = className
    }

    // MARK: - Public Class
    public class func registerClass(){
        do {
            try BaseObjectService(kls: self).registerSubClass()
        }
        catch let error {
            print(error)
        }
    }
    
    public class func unRegisterClass(){
        do {
            try BaseObjectService(kls: self).unRegisterSubClass()
        }
        catch let error {
            print(error)
        }
    }
    
    // MARK: - Public Method
    public func fetch() -> Bool {
        do {
            try store.getObject()
            return true
        }
        catch let error {
            print(error)
            return false
        }
    }
    
    public func pin(){
        do {
            try store.changeObject()
        }
        catch let error{
            print(error)
        }
    }
    
    public func unpin() -> Bool {
        do {
            return try store.removeObject() > 0
        }
        catch let error{
            print(error)
            return false
        }
    }
    
    public func unPinAll() -> Bool {
        do {
            return try store.removeAllObject() > 0
        }
        catch let error{
            print(error)
            return false
        }
    }
    
}

