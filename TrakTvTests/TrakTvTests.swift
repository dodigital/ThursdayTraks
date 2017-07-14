//
//  TrakTvTests.swift
//  TrakTvTests
//
//  Created by Daniel Okoronkwo on 14/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import XCTest
@testable import TrakTv

class TrakTvTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testperformTrackTRequests(){
    
        let expectation = self.expectation(description: "Did receive data")
        
        APIManager.sharedInstance.performTrackTRequests(requestType: APIManager.tracktRequestype.people, movie: nil) { (status, any) in
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            // Write asserts here
        }
    }
    
}
