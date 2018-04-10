//
//  KnotSocketIOTests.swift
//  KnotTestTests
//
//  Created by Rafael Lucena on 3/3/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import XCTest
@testable import KnotTest

class KnotHttpTests: XCTestCase {
    
    let thingUUID = "28acfe24-a276-43c1-b6e0-b4d2d1710001"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidKnotHttpMyDevicesRequest() {
        let responseExpectation = expectation(description: "request response")
        let validResponseExpectation = expectation(description: "valid response expectation")
        
        KnotHttp().myDevices { (data, error) in
            if error == nil {
                responseExpectation.fulfill()
            }
            
            if data != nil {
                validResponseExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15) { (error) in
            XCTAssert(error == nil)
        }
    }
    
    func testValidKnotHttpDataRequest() {
        let responseExpectation = expectation(description: "request response")
        let validResponseExpectation = expectation(description: "valid response expectation")

        KnotHttp().data(deviceUUID: thingUUID) { (data, error) in
            if error == nil {
                responseExpectation.fulfill()
            }
            
            if data != nil {
                validResponseExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15) { (error) in
            XCTAssert(error == nil)
        }
    }
}
