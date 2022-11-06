//
//  Config.swift
//  minicron-framework
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

public enum ConfigFormatError: Error {
    case invalidParametersCount(Int)
    case invalidConfigValue(String)
}

public struct Config {
    public let time: CronTime
    public let task: String
    
    public init(line: String) throws {
        let values = line.components(separatedBy: .whitespaces)
        if values.count != 3 {
            throw ConfigFormatError.invalidParametersCount(values.count)
        }
        let m = values[0] as String
        let h = values[1] as String
        let t = values[2] as String
        let hours = try ConfigValue(h)
        let minutes = try ConfigValue(m)
        self.time = try CronTime(hours: hours, minutes: minutes)
        self.task = t
    }
}
