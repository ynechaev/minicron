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

    func testCronTimeCompareSimplePrior() throws {
        let current = try CronTime(hours: .init(15), minutes: .init(10))
        let job = try CronTime(hours: .init(15), minutes: .value(30))

        XCTAssertTrue(current < job)
    }
    
    func testCronTimeCompareSimpleAfter() throws {
        let current = try CronTime(hours: .init(15), minutes: .init(30))
        let job = try CronTime(hours: .init(15), minutes: .value(10))

        XCTAssertTrue(current > job)
    }
    
    func testCronTimeCompareSimpleAfterNextDay() throws {
        let current = try CronTime(hours: .init(23), minutes: .init(30))
        let job = try CronTime(hours: .init(00), minutes: .value(15))

        XCTAssertTrue(current > job)
    }
    
    func testCronTimeCompareSimpleAfterNextDayWildcard() throws {
        let current = try CronTime(hours: .init(23), minutes: .init(30))
        let job = try CronTime(hours: .wildcard, minutes: .value(15))

        XCTAssertTrue(current > job)
    }
    
    func testCronTimeCompareSimpleSameTime() throws {
        let current = try CronTime(hours: .init(12), minutes: .init(00))
        let job = try CronTime(hours: .init(12), minutes: .init(00))

        XCTAssertTrue(current < job)
    }
    
    func testCronTimeCompareWildcardSameTime() throws {
        let current = try CronTime(hours: .init(12), minutes: .init(00))
        let job = try CronTime(hours: .wildcard, minutes: .init(00))

        XCTAssertTrue(job < current)
    }
    
    func testCronTimeCompareWildcards() throws {
        let current = try CronTime(hours: .wildcard, minutes: .wildcard)
        let job = try CronTime(hours: .wildcard, minutes: .wildcard)

        XCTAssertTrue(current < job)
    }

    func testCronTimeCompareWildcard() throws {
        let current = try CronTime(hours: .init(15), minutes: .init(10))
        let job = try CronTime(hours: .wildcard, minutes: .value(30))
        
        XCTAssertTrue(current < job)
    }
    
    // MARK: - Short and long notation - 1:30 instead of 01:30
    
    func testCronTimeShortNotationForTime() throws {
        // given
        let job = try CronTime(hours: .init(1), minutes: .init(1))
        
        // when
        let string = job.asString()
        
        // then
        XCTAssertEqual(string, "1:01")
    }
    
    // MARK: - next trigger tests
    
    func testCronNextTriggerSimple() throws {
        // given
        let current = try CronTime(hours: .init(15), minutes: .init(10))
        let job = try CronTime(hours: .init(15), minutes: .value(30))

        // when
        let next = job.nextTrigger(against: current)
        
        // then
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"15:30 today"))
    }
    
    func testCronNextTriggerWildcardHours() throws {
        // given
        let current = try CronTime(hours: .init(15), minutes: .init(10))
        let job = try CronTime(hours: .wildcard, minutes: .value(30))

        // when
        let next = job.nextTrigger(against: current)
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"15:30 today"))
    }
    
    func testCronNextTriggerWildcardAll() throws {
        // given
        let current = try CronTime(hours: .init(15), minutes: .init(10))
        let job = try CronTime(hours: .wildcard, minutes: .wildcard)

        // when
        let next = job.nextTrigger(against: current)
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"15:10 today"))
    }
    
    func testCronNextTriggerWildcardMinutes() throws {
        // given
        let current = try CronTime(hours: .init(15), minutes: .init(10))
        let job = try CronTime(hours: .init(15), minutes: .wildcard)

        // when
        let next = job.nextTrigger(against: current)
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"15:10 today"))
    }
    
    func testCronNextTriggerTomorrow() throws {
        // given
        let current = try CronTime(hours: .init(15), minutes: .init(10))
        let job = try CronTime(hours: .init(14), minutes: .init(30))

        // when
        let next = job.nextTrigger(against: current)
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"14:30 tomorrow"))
    }
    
    func testCronNextTriggerTomorrowMidnight() throws {
        // given
        let current = try CronTime(hours: .init(23), minutes: .init(30))
        let job = try CronTime(hours: .wildcard, minutes: .init(15))

        // when
        let next = job.nextTrigger(against: current)
        
        // then
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"0:15 tomorrow"))
    }
    
    func testCronNextTriggerTomorrowMidnightZero() throws {
        // given
        let current = try CronTime(hours: .init(23), minutes: .init(59))
        let job = try CronTime(hours: .init(0), minutes: .init(0))

        // when
        let next = job.nextTrigger(against: current)
        
        // then
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"0:00 tomorrow"))
    }
    
    func testCronNextEqual() throws {
        // given
        let current = try CronTime(hours: .init(23), minutes: .init(59))
        let job = try CronTime(hours: .init(23), minutes: .init(59))

        // when
        let next = job.nextTrigger(against: current)
        
        // then
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"23:59 today"))
    }
    
    // MARK: - Boundaries
    
    func testCronHour24() throws {
        do {
            let _ = try CronTime(hours: .init(24), minutes: .wildcard)
            XCTFail("Expected to throw")
        } catch {
            XCTAssert(true)
        }
    }
    
    func testCronMinute60() throws {
        do {
            let _ = try CronTime(hours: .wildcard, minutes: .value(60))
            XCTFail("Expected to throw")
        } catch {
            XCTAssert(true)
        }
    }

}

// MARK: - Task test suite
extension CronTimeTests {
    
    func testCronDaily() throws {
        // given
        let current = try CronTime(hours: .init(16), minutes: .init(10))
        let job = try CronTime(hours: .init(1), minutes: .init(30))
        
        // when
        let next = job.nextTrigger(against: current)

        // then
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"1:30 tomorrow"))
    }
    
    func testCronHourly() throws {
        // given
        let current = try CronTime(hours: .init(16), minutes: .init(10))
        let job = try CronTime(hours: .init(16), minutes: .init(45))
        
        // when
        let next = job.nextTrigger(against: current)

        // then
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"16:45 today"))
    }
    
    func testCronEveryMinute() throws {
        // given
        let current = try CronTime(hours: .init(16), minutes: .init(10))
        let job = try CronTime(hours: .wildcard, minutes: .wildcard)
        
        // when
        let next = job.nextTrigger(against: current)

        // then
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"16:10 today"))
    }
    
    func testCronSixtyTimes() throws {
        // given
        let current = try CronTime(hours: .init(16), minutes: .init(10))
        let job = try CronTime(hours: .init(19), minutes: .wildcard)
        
        // when
        let next = job.nextTrigger(against: current)

        // then
        XCTAssertEqual(next, NextTriggerOutput(rawValue:"19:00 today"))
    }
    
}
