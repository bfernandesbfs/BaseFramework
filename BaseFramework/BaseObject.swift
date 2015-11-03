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
    
    // MARK: - Public Class
    public class func registerClass(){
        BaseObjectStore(kls: self).registerSubClass()
    }
    
    public class func unRegisterClass(){
        BaseObjectStore(kls: self).unRegisterSubClass()
    }
    
    // MARK: - Public Method
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
    
    public func unpin() -> Bool {
        return store.removeObject() > 0
    }
    
    public func unPinAll() -> Bool {
        return store.removeAllObject() > 0
    }
    
}

