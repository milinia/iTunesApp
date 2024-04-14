//
//  TimeConverterTests.swift
//  iTunesSearchTests
//
//  Created by Evelina on 14.04.2024.
//

import Foundation
import XCTest
@testable import iTunesSearch

final class TimeConverterTests: XCTestCase {

    func testCorrectConverting() throws {
        //given
        let timeMillis = 318000
        //when
        let convertedTime = TimeConverter.convertToMin(millis: timeMillis)
        //then
        XCTAssertEqual(convertedTime, "5:18")
    }
    
    func testAddNumberWhenConverting() throws {
        //given
        let timeMillis = 187000
        //when
        let convertedTime = TimeConverter.convertToMin(millis: timeMillis)
        //then
        XCTAssertEqual(convertedTime, "3:07")
    }
    
    func testHoursConverting() throws {
        //given
        let timeMillis = 7920000
        //when
        let convertedTime = TimeConverter.convertToMin(millis: timeMillis)
        //then
        XCTAssertEqual(convertedTime, "2:12:00")
    }
}
