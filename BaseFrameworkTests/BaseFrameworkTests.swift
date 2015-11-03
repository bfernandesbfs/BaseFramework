//
//  BaseFrameworkTests.swift
//  BaseFrameworkTests
//
//  Created by Bruno Fernandes on 29/10/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import XCTest
import BaseFramework

class BaseFrameworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateObject() {

        People.registerClass()
        
    }
    
    func testDropObject() {
        
        People.unRegisterClass()
        
    }
    
    func testSaveObject(){
        
        let people:People = People()
        people.unPinAll()
        //people.firstName = "Bruno"
        people.lastName = "Fernandes"
        people.age  = 29
        people.register = 123456
        people.register1 = NSNumber(double: 0.5555)
        people.isN = false
        
        people.data = "Oiiiiiii".dataUsingEncoding(NSUTF8StringEncoding)
        
        people.pin()
        
        XCTAssertFalse(people.objectId == nil, "Create Pin success")
        
        
        
    }
    
    func testRemoveObject() {

        let people:People = People()
        people.objectId = 4
        
        XCTAssert(people.unpin(), "UnPin data change")
    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
