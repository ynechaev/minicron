//
//  ConfigValue.swift
//  minicron-framework
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

public enum CronWhen: String {
    case today = "today"
    case tomorrow = "tomorrow"
}

public enum TimeType {
    case hours
    case minutes
}

public enum CronValue: Comparable {
    static let hoursRange = 0...23
    static let minutesRange = 0...59
    
    /// This value was UInt first, but then was changed to Int
    /// to support type safety https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
    case value(Int, TimeType)
    case wildcard
    
    init(_ value: String, type: TimeType) throws {
        if value == "*" {
            self = .wildcard
        } else {
            try CronValue.validateDigits(value)
            let intVal = Int(value) ?? 0
            try CronValue.validate(intVal, type: type)
            self = .value(intVal, type)
        }
    }
    
    init(_ value: Int, type: TimeType) throws {
        try CronValue.validate(value, type: type)
        self = .value(value, type)
    }
    
    /// Represent time struct in a human readable format
    /// - Parameter long: Render extra preceding zero
    /// - Returns: Time string with format hh:mm
    public func asString() -> String {
        if case .value(let int, let type) = self {
            switch type {
            case .hours:
                return String(format: "%d", int)
            case .minutes:
                return String(format: "%02d", int)
            }
        } else {
            return "*"
        }
    }
    
    public static func < (lhs: CronValue, rhs: CronValue) -> Bool {
        if case .value(let int1, _) = lhs, case .value(let int2, _) = rhs {
            return int1 == int2 || int1 < int2
        } else {
            if case .wildcard = lhs {
                return true
            }
        }
        return false
    }
    
    public static func == (lhs: CronValue, rhs: CronValue) -> Bool {
        if case .wildcard = lhs {
            return true
        }
        
        if case .wildcard = rhs {
            return true
        }
        
        if case .value(let lInt, _) = lhs, case .value(let rInt, _) = rhs {
            return lInt == rInt
        }
        
        return false
    }
    
    // MARK: - Validation (Private)
    
    private static func validate(_ value: Int, type: TimeType) throws {
        switch type {
        case .hours:
            guard hoursRange.contains(value) else {
                throw CronError.invalidHoursRange(value)
            }
        case .minutes:
            guard minutesRange.contains(value) else {
                throw CronError.invalidMinutesRange(value)
            }
        }
    }
    
    private static func validateDigits(_ string: String) throws {
        guard string.isNumber else {
            throw CronError.invalidNumber(string)
        }
    }

}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
