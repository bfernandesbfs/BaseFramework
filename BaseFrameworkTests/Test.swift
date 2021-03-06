//
//  Test.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 29/10/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation
import BaseFramework

public class People: BaseObject, SubObject  {
    
    var firstName:NSString!
    var lastName:String!
    var age:Int
    var age1:Float
    var register:Double
    var isN:Bool
    var register1:NSNumber!
    var data:NSData!
    var date:NSDate!
    
    
//    override public class func initialize() {
//        struct Static {
//            static var onceToken : dispatch_once_t = 0;
//        }
//        dispatch_once(&Static.onceToken) {
//            self.registerClass()
//        }
//    }
//    
    public static func objClassName() -> String {
        return "People_2"
    }
    
    override init() {
        lastName  = ""
        age  = 0
        age1 = 0
        isN = false
        register = 0
        super.init()
    }
}
