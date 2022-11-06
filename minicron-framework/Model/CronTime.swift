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

enum CronWhen: String {
    case today = "today"
    case tomorrow = "tomorrow"
}

public struct CronTime: Comparable {
    let hours: ConfigValue
    let minutes: ConfigValue
    
    static let hoursRange = 0...23
    static let minutesRange = 0...59
    
    public func asString() -> String {
        [hours.asString(long: false), minutes.asString(long: true)].joined(separator: ":")
    }
    
    public func nextTrigger(against currentTime: CronTime) -> String {
        let equal: Bool = self == currentTime
        let today: CronWhen = equal ? .today : currentTime < self ? .today : .tomorrow
                
        var h = today == .today ? max(hours, currentTime.hours) : hours
        var m = today == .today && hours == currentTime.hours ? max(minutes, currentTime.minutes) : minutes
        
        if case ConfigValue.wildcard = h {
            h = ConfigValue(0)
        }
        
        if case ConfigValue.wildcard = m {
            m = ConfigValue(0)
        }
        
        let trigger = try! CronTime(hours: h, minutes: m)
        
        return String(format: "%@ %@", trigger.asString(), today.rawValue)
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
