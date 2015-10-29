//
//  BaseObject.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 29/10/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation

public class BaseObject:NSObject {
    
    private var store:BaseObjectStore!
    
    public var objectId:Int!
    public var updatedAt:NSDate!
    public var createdAt:NSDate!
    
    public var objClassName:String!
    
    override public var description:String {
        return store.debugDescription
    }
    
    override public init() {
        super.init()
        
        store = BaseObjectStore(kls: self)

    }
    
    public init(className:String){
        
        objClassName = className
    }
    
    public class func registerClass(){
        print("Register")
        
        BaseObjectStore(kls: self).registerSubClass()
        
    }
    
    public class func unRegisterClass(){
        print("drop Register")
        
        BaseObjectStore(kls: self).unRegisterSubClass()
        
    }
    
    
    public func pin(){
        store.saveObject()
        
    }
    
    public func pin(change:Bool){
        
        if change {
            store.changeObject()
        }
        else{
            store.saveObject()
        }
        
    }
    
    public func unpin(){
        store.removeObject()
    }
    
}

