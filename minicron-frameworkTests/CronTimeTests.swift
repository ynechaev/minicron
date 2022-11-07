//
//  CronTimeTests.swift
//  minicron-frameworkTests
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import XCTest
@testable import minicron_framework

final class CronTimeTests: XCTestCase {
    
    // MARK: - Comparator tests

    func testCronTimeCompareSimplePrior() {
        let current = CronTime(rawValue: "15:10")!
        let job = CronTime(rawValue: "15:30")!

        XCTAssertTrue(current < job)
    }
    
    func testCronTimeCompareSimpleAfter() {
        let current = CronTime(rawValue: "15:30")!
        let job = CronTime(rawValue: "15:10")!

        XCTAssertTrue(current > job)
    }
    
    func testCronTimeCompareSimpleAfterNextDay() {
        let current = CronTime(rawValue: "23:30")!
        let job = CronTime(rawValue: "0:15")!

        XCTAssertTrue(current > job)
    }
    
    func testCronTimeCompareSimpleAfterNextDayWildcard() {
        let current = CronTime(rawValue: "23:30")!
        let job = CronTime(rawValue: "*:15")!

        XCTAssertTrue(current > job)
    }
    
    func testCronTimeCompareSimpleSameTime() {
        let current = CronTime(rawValue: "12:00")!
        let job = CronTime(rawValue: "12:00")!

        XCTAssertEqual(current, job)
    }
    
    func testCronTimeCompareWildcardSameTime() {
        let current = CronTime(rawValue: "12:00")!
        let job = CronTime(rawValue: "*:00")!

        XCTAssertTrue(job < current)
    }
    
    func testCronTimeCompareWildcards() {
        let current = CronTime(rawValue: "*:*")!
        let job = CronTime(rawValue: "*:*")!

        XCTAssertTrue(current == job)
    }

    func testCronTimeCompareWildcard() {
        let current = CronTime(rawValue: "15:10")!
        let job = CronTime(rawValue: "*:30")!
        
        XCTAssertTrue(current < job)
    }
    
    // MARK: - Short and long notation - 1:30 instead of 01:30
    
    func testCronTimeShortNotationForTime() {
        // given
        let job = CronTime(rawValue: "01:01")!
        
        // when
        let string = job.asString()
        
        // then
        XCTAssertEqual(string, "1:01")
    }
    
    // MARK: - next trigger tests
    
    func testCronNextTriggerSimple() {
        // given
        let current = CronTime(rawValue: "15:10")!
        let job = CronTime(rawValue: "15:30")!

        // when
        let next = job.nextTrigger(against: current)
        
        // then
        XCTAssertEqual(next, CronOutput(rawValue:"15:30 today"))
    }
    
    func testCronNextTriggerWildcardHours() {
        // given
        let current = CronTime(rawValue: "15:10")!
        let job = CronTime(rawValue: "*:30")!

        // when
        let next = job.nextTrigger(against: current)
        XCTAssertEqual(next, CronOutput(rawValue:"15:30 today"))
    }
    
    func testCronNextTriggerWildcardAll() {
        // given
        let current = CronTime(rawValue: "15:10")!
        let job = CronTime(rawValue: "*:*")!

        // when
        let next = job.nextTrigger(against: current)
        XCTAssertEqual(next, CronOutput(rawValue:"15:10 today"))
    }
    
    func testCronNextTriggerWildcardMinutes() {
        // given
        let current = CronTime(rawValue: "15:10")!
        let job = CronTime(rawValue: "15:*")!

        // when
        let next = job.nextTrigger(against: current)
        XCTAssertEqual(next, CronOutput(rawValue:"15:10 today"))
    }
    
    func testCronNextTriggerTomorrow() {
        // given
        let current = CronTime(rawValue: "15:10")!
        let job = CronTime(rawValue: "14:30")!

        // when
        let next = job.nextTrigger(against: current)
        XCTAssertEqual(next, CronOutput(rawValue:"14:30 tomorrow"))
    }
    
    func testCronNextTriggerTomorrowMidnight() {
        // given
        let current = CronTime(rawValue: "23:30")!
        let job = CronTime(rawValue: "*:15")!

        // when
        let next = job.nextTrigger(against: current)
        
        // then
        XCTAssertEqual(next, CronOutput(rawValue:"0:15 tomorrow"))
    }
    
    func testCronNextTriggerTomorrowMidnightZero() {
        // given
        let current = CronTime(rawValue: "23:59")!
        let job = CronTime(rawValue: "0:00")!

        // when
        let next = job.nextTrigger(against: current)
        
        // then
        XCTAssertEqual(next, CronOutput(rawValue:"0:00 tomorrow"))
    }
    
    func testCronNextEqual() {
        // given
        let current = CronTime(rawValue: "23:59")!
        let job = CronTime(rawValue: "23:59")!

        // when
        let next = job.nextTrigger(against: current)
        
        // then
        XCTAssertEqual(next, CronOutput(rawValue:"23:59 today"))
    }
    
    // MARK: - Boundaries
    
    func testCronHour24() {
        XCTAssertNil(CronTime(rawValue: "24:*"))
    }
    
    func testCronMinute60() throws {
        XCTAssertNil(CronTime(rawValue: "*:60"))
    }
    
    func testCronRandom() throws {
        XCTAssertNil(CronTime(rawValue: "$%!@#@"))
    }

}

// MARK: - Task test suite
extension CronTimeTests {
    
    func testCronDaily() {
        // given
        let current = CronTime(rawValue: "16:10")!
        let job = CronTime(rawValue: "1:30")!
        
        // when
        let next = job.nextTrigger(against: current)

        // then
        XCTAssertEqual(next, CronOutput(rawValue:"1:30 tomorrow"))
    }
    
    func testCronHourly() {
        // given
        let current = CronTime(rawValue: "16:10")!
        let job = CronTime(rawValue: "16:45")!
        
        // when
        let next = job.nextTrigger(against: current)

        // then
        XCTAssertEqual(next, CronOutput(rawValue:"16:45 today"))
    }
    
    func testCronEveryMinute() {
        // given
        let current = CronTime(rawValue: "16:10")!
            let job = CronTime(rawValue: "*:*")!
        
        // when
        let next = job.nextTrigger(against: current)

        // then
        XCTAssertEqual(next, CronOutput(rawValue:"16:10 today"))
    }
    
    func testCronSixtyTimes() {
        // given
        let current = CronTime(rawValue: "16:10")!
        let job = CronTime(rawValue: "19:*")!
        
        // when
        let next = job.nextTrigger(against: current)

        // then
        XCTAssertEqual(next, CronOutput(rawValue:"19:00 today"))
    }
    
}
