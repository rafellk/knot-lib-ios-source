//
//  KnotSocketIOTests.swift
//  KnotTestTests
//
//  Created by Rafael Lucena on 3/3/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import XCTest
@testable import KnotTest

class KnotSocketIOTests: XCTestCase {
    
    // MARK: Success Mocked input values
    let thingUUID = "28acfe24-a276-43c1-b6e0-b4d2d1710001"
    let sensorID = 2
    let sensorValue = true
    
    // MARK: Fail Mocked input values
    let invalidThingUUID = "invalid thing uuid"
    let invalidSensorID = 87234
    let invalidSensorValue = 30.2
    
    // MARK: Generic variables
    let knotSocketIO = KnotSocketIO()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidKnotSocketIOGetDevicesRequest() {
        let responseExpectation = expectation(description: "request response expectation")
        let validResponseExpectation = expectation(description: "valid response expectation")
        
        knotSocketIO.getDevices { (data, error) in
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
    
    func testValidKnotSocketIOGetDataRequest() {
        let responseExpectation = expectation(description: "request response")
        let validResponseExpectation = expectation(description: "valid response expectation")
        
        knotSocketIO.getData(thingUUID: thingUUID, sensorID: sensorID) { (data, error) in
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
    
    func testValidKnotSocketIOSetDataRequest() {
        let responseExpectation = expectation(description: "request response")
        let validResponseExpectation = expectation(description: "valid response expectation")
        
        knotSocketIO.setData(thingUUID: thingUUID, sensorID: sensorID, value: sensorValue) { (data, error) in
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
