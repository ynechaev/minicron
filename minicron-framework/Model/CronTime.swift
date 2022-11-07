//
//  CronModel.swift
//  minicron-framework
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

public enum CronError: Error {
    case invalidSimulatedTime(String)
    case invalidHoursRange(UInt)
    case invalidMinutesRange(UInt)
}

/// Main time (hours and minutes) container. Input values are validated.
public struct CronTime: Comparable {
    let hours: ConfigValue
    let minutes: ConfigValue
    
    static let hoursRange = 0...23
    static let minutesRange = 0...59
    
    /// Human readable representation
    /// - Returns: A String of a format hh:mm
    public func asString() -> String {
        [hours.asString(long: false), minutes.asString(long: true)].joined(separator: ":")
    }
    
    /// Calculate next task trigger time
    /// - Parameter currentTime: current time against which the calculation will be performed
    /// - Returns: NextTriggerOutput struct
    public func nextTrigger(against currentTime: CronTime) -> NextTriggerOutput {
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
        
        if case ConfigValue.wildcard = h {
            h = ConfigValue(0)
        }
        
        if case ConfigValue.wildcard = m {
            m = ConfigValue(0)
        }
        
        // Create trigger time struct
        let trigger = try! CronTime(hours: h, minutes: m)
        return NextTriggerOutput(time: trigger, when: when)
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
    
    public init(hours: ConfigValue, minutes: ConfigValue) throws {
        if case ConfigValue.value(let int) = hours {
            try CronTime.validateHours(int)
        }
        
        if case ConfigValue.value(let int) = minutes {
            try CronTime.validateMinutes(int)
        }
        
        self.hours = hours
        self.minutes = minutes
    }
    
    public init(hours: UInt, minutes: UInt) throws {
        try CronTime.validateHours(hours)
        try CronTime.validateMinutes(minutes)
        
        self.hours = ConfigValue(hours)
        self.minutes = ConfigValue(minutes)
    }
    
    /// Initialize with arg string directly
    /// - Parameter argString: Argument string of format hh:mm
    public init(argString: String) throws {
        let comps = argString.components(separatedBy: ":")
        if comps.count != 2 {
            throw CronError.invalidSimulatedTime(argString)
        }
        let h = comps[0]
        let m = comps[1]
        self.hours = try ConfigValue(h)
        self.minutes = try ConfigValue(m)
    }
    
    // MARK: - Validation (Private)
    
    private static func validateHours(_ hours: UInt) throws {
        guard hoursRange.contains(Int(hours)) else {
            throw CronError.invalidHoursRange(hours)
        }
    }
    
    private static func validateMinutes(_ minutes: UInt) throws {
        guard minutesRange.contains(Int(minutes)) else {
            throw CronError.invalidMinutesRange(minutes)
        }
    }
}
