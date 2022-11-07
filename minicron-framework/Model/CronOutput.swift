//
//  NextTriggerOutput.swift
//  minicron-framework
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

/// Output processing model
public struct CronOutput: RawRepresentable, Equatable {
    public var rawValue: String
    
    public typealias RawValue = String
    
    let time: CronTime
    let when: CronWhen
    
    public init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: CharacterSet.whitespaces)
        guard let time = try? CronTime(argString: parts[0]),
              let when = CronWhen(rawValue: parts[1]) else {
            return nil
        }
        self.time = time
        self.when = when
        self.rawValue = rawValue
    }
    
    public init(time: CronTime, when: CronWhen) {
        self.time = time
        self.when = when
        self.rawValue = String(format: "%@ %@", time.asString(), when.rawValue)
    }

}
