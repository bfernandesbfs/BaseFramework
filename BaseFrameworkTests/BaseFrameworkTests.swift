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
    
    func testSaveObject(){
        
        let people:People = People()
        people.lastName = "Fernandes"
        people.age  = 29
        people.isN = false
        
        people.pin()
        
        print(people.description)
    }
    
    func testRemoveObject() {

        let people:People = People()
        people.objectId = 1

        people.unpin()
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
