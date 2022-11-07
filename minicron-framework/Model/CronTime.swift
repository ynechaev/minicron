//
//  CronModel.swift
//  minicron-framework
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

public enum CronError: Error {
    case invalidSimulatedTime(String)
    case invalidHoursRange(Int)
    case invalidMinutesRange(Int)
    case invalidNumber(String)
}

/// Main time (hours and minutes) container. Input values are validated.
public struct CronTime: Comparable, RawRepresentable {
    
    public var rawValue: String
    
    public typealias RawValue = String
    
    let hours: CronValue
    let minutes: CronValue
    
    public init?(rawValue: String) {
        let comps = rawValue.components(separatedBy: ":")
        if comps.count == 2 {
            let h = comps[0]
            let m = comps[1]
            if let hours = try? CronValue(h, type: .hours),
               let minutes = try? CronValue(m, type: .minutes) {
                self.hours = hours
                self.minutes = minutes
                self.rawValue = [hours.asString(), minutes.asString()].joined(separator: ":")
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// Human readable representation
    /// - Returns: A String of a format hh:mm
    public func asString() -> String {
        [hours.asString(), minutes.asString()].joined(separator: ":")
    }
    
    /// Calculate next task trigger time
    /// - Parameter currentTime: current time against which the calculation will be performed
    /// - Returns: NextTriggerOutput struct
    public func nextTrigger(against currentTime: CronTime) -> CronOutput {
        // check if task and current time are equal
        let equal: Bool = self == currentTime
        
        // task will be considered equal even if it matches using wildcard symbols '*'
        let when: CronWhen = equal ? .today : currentTime < self ? .today : .tomorrow
                
        // Take max hour if planned for today, otherwise just take task hours
        var h = when == .today ? max(hours, currentTime.hours) : hours
        
        // Take max minute if task planned for today and hour is equal, otherwise
        // just take task minutes
        var m = when == .today && hours == currentTime.hours ? max(minutes, currentTime.minutes) : minutes
        
        // Replace wildcard with zeros
        
        if case CronValue.wildcard = h {
            h = try! CronValue(0, type: .hours)
        }
        
        if case CronValue.wildcard = m {
            m = try! CronValue(0, type: .minutes)
        }
        
        // Create trigger time struct
        let trigger = CronTime(hours: h, minutes: m)
        return CronOutput(time: trigger, when: when)
    }
    
    public static func < (lhs: CronTime, rhs: CronTime) -> Bool {
        if lhs.hours == rhs.hours {
            return lhs.minutes < rhs.minutes
        } else {
            return lhs.hours < rhs.hours
        }
    }
    
    public static func == (lhs: CronTime, rhs: CronTime) -> Bool {
        return lhs.hours == rhs.hours && lhs.minutes == rhs.minutes
    }
    
    public init(hours: CronValue, minutes: CronValue) {
        self.hours = hours
        self.minutes = minutes
        self.rawValue = [hours.asString(), minutes.asString()].joined(separator: ":")
    }
    
    public init(_ hours: Int, _ minutes: Int) throws {
        self.hours = try CronValue(hours, type: .hours)
        self.minutes = try CronValue(minutes, type: .minutes)
        self.rawValue = [self.hours.asString(), self.minutes.asString()].joined(separator: ":")
    }
    
}
