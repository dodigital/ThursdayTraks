//
//  MovieTests.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 14/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import XCTest
@testable import TrakTv

class MovieTests: XCTestCase {
    
    var movie : Movie!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitializer(){
        
        // GIVEN
        let testMovie = Movie(movieID: 0, title: "TEST", rating: 5, movieSummary: "TEST", genreArray: ["comedy","thriller"], releaseYear: 2014, certRating: "PG-13")
        //THEN
        XCTAssertNotNil(testMovie)
        
    }
    
    func testUpdateImagePath(){
        // GIVEN
        let testMovie = Movie(movieID: 0, title: "TEST", rating: 5, movieSummary: "TEST", genreArray: ["comedy","thriller"], releaseYear: 2014, certRating: "PG-13")
        // WHEN
        testMovie.updateImagePath(path: "PATH")
        // THEN
        XCTAssertNil(testMovie.imagePath)
    }
    
}
