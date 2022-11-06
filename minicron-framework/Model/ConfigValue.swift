//
//  ConfigValue.swift
//  minicron-framework
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

public enum ConfigValue: Comparable {
    
    case value(UInt)
    case wildcard
    
    init(_ value: String) throws {
        if value == "*" {
            self = .wildcard
        } else {
            let numbersRange = value.rangeOfCharacter(from: .decimalDigits)
            let hasNumbers = (numbersRange != nil)
            if !hasNumbers {
                throw ConfigFormatError.invalidConfigValue(value)
            } else {
                self = .value(UInt(value) ?? 0)
            }
        }
    }
    
    init(_ value: UInt) {
        self = .value(value)
    }
    
    public func asString(long: Bool) -> String {
        if case .value(let int) = self {
            if long {
                return String(format: "%02d", int)
            } else {
                return String(format: "%d", int)
            }
        } else {
            return "*"
        }
    }
    
    public static func < (lhs: ConfigValue, rhs: ConfigValue) -> Bool {
        if case .value(let int1) = lhs, case .value(let int2) = rhs {
            return int1 == int2 || int1 < int2
        } else {
            if case .wildcard = lhs {
                return true
            }
        }
        return false
    }
    
    public static func == (lhs: ConfigValue, rhs: ConfigValue) -> Bool {
        if case .wildcard = lhs {
            return true
        }
        
        if case .wildcard = rhs {
            return true
        }
        
        if case .value(let lInt) = lhs, case .value(let rInt) = rhs {
            return lInt == rInt
        }
        
        return false
    }
    
}
