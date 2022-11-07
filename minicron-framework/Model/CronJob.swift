//
//  Config.swift
//  minicron-framework
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

public enum JobFormatError: Error {
    case invalidParametersCount(Int)
    case invalidConfigValue(String)
}

public struct CronJob {
    public let time: CronTime
    public let task: String
    
    public init(line: String) throws {
        let values = line.components(separatedBy: .whitespaces)
        if values.count != 3 {
            throw JobFormatError.invalidParametersCount(values.count)
        }
        let m = values[0] as String
        let h = values[1] as String
        let t = values[2] as String
        let hours = try CronValue(h, type: .hours)
        let minutes = try CronValue(m, type: .minutes)
        self.time = CronTime(hours: hours, minutes: minutes)
        self.task = t
    }
}
