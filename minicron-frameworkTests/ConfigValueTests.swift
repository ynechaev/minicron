//
//  ConfigValueTests.swift
//  minicron-frameworkTests
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import XCTest
@testable import minicron_framework

final class CronValueTests: XCTestCase {
    
    // MARK: - Init tests
    
    func testInitHoursWithIntValid() {
        XCTAssertNotNil(try? CronValue(12, type: .hours))
    }
    
    func testInitHoursWithStringValid() {
        XCTAssertNotNil(try? CronValue("12", type: .hours))
    }
    
    func testInitMinutesWithIntValid() {
        XCTAssertNotNil(try? CronValue(12, type: .minutes))
    }
    
    func testInitMinutesWithStringValid() {
        XCTAssertNotNil(try? CronValue("12", type: .minutes))
    }
    
    func testInitHoursWithWildcardValid() {
        XCTAssertNotNil(try? CronValue("*", type: .hours))
    }
    
    func testInitMinutesWithWildcardValid() {
        XCTAssertNotNil(try? CronValue("*", type: .minutes))
    }
    
    // MARK: - Validation tests
    
    func testValidateMinutes() {
        XCTAssertNil(try? CronValue(60, type: .minutes))
    }
    
    func testValidateHours() {
        XCTAssertNil(try? CronValue(24, type: .hours))
    }
    
    func testValidateNegativeMinutes() {
        XCTAssertNil(try? CronValue(-30, type: .minutes))
    }
    
    func testValidateNegativeHours() {
        XCTAssertNil(try? CronValue(-12, type: .hours))
    }
    
    // MARK: - Output tests
    
    func testHoursAsString() {
        // given
        let value = try? CronValue("12", type: .hours)
        
        // then
        XCTAssertEqual("12", value?.asString())
    }
    
    func testHoursShortAsString() {
        // given
        let value = try? CronValue("01", type: .hours)
        
        // then
        XCTAssertEqual("1", value?.asString())
    }
    
    func testMinutesAsString() {
        // given
        let value = try? CronValue("12", type: .minutes)
        
        // then
        XCTAssertEqual("12", value?.asString())
    }
    
    func testMinutesLongAsString() {
        // given
        let value = try? CronValue("1", type: .minutes)
        
        // then
        XCTAssertEqual("01", value?.asString())
    }
    
    func testMinutesWildcardAsString() {
        // given
        let value = try? CronValue("*", type: .minutes)
        
        // then
        XCTAssertEqual("*", value?.asString())
    }
    
    func testHoursWildcardAsString() {
        // given
        let value = try? CronValue("*", type: .hours)
        
        // then
        XCTAssertEqual("*", value?.asString())
    }
    
    // MARK: - Compare tests
    
    func testLess() {
        // given
        let lhs = try! CronValue("12", type: .hours)
        let rhs = try! CronValue("13", type: .hours)
        
        // then
        XCTAssertTrue(lhs < rhs)
    }
    
    func testEqual() {
        // given
        let lhs = try! CronValue("01", type: .hours)
        let rhs = try! CronValue("1", type: .hours)
        
        // then
        XCTAssertTrue(lhs == rhs)
    }
    
    func testLessWildcard() {
        // given
        let lhs = try! CronValue("*", type: .hours)
        let rhs = try! CronValue("1", type: .hours)
        
        // then
        XCTAssertTrue(lhs < rhs)
    }
    
}
