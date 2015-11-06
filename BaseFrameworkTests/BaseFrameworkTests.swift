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
        //people.firstName = "Bruno"
        people.lastName = "Fernandes 2"
        people.age  = 15
        people.register = 654321
        people.register1 = NSNumber(double: 0.4545)
        people.isN = true
        
        //people.data = "Chaooooo".dataUsingEncoding(NSUTF8StringEncoding)
        
        people.pin()
        
        //people.firstName = "Brunoooo"
        
        //people.pin()
        
        XCTAssertFalse(people.objectId == nil, "Create Pin success")
        
    }
    
    func testChangeObject() {
        
        let people:People = People()
        people.objectId = 2
        
        people.fetch()
    
        print("objectId",people.objectId)
        print("firstName",people.firstName == nil ? "nil" : people.firstName  )
        print("lastName",people.lastName)
        print("age",people.age)
        print("age1",people.age1)
        print("isN",people.isN)
        print("register",people.register)
        print("register1",people.register1)
        print("date",people.date == nil ? "nil" : people.date)
        print("data",people.data == nil ? "nil" : people.data)
        
    }
    
    func testRemoveObject() {

        let people:People = People()
        people.objectId = 5
        
        
        
        XCTAssert(people.unpin(), "UnPin data change")
    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
