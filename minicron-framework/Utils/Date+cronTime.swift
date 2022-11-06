//
//  Date+cronTime.swift
//  minicron-framework
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

// Support Date -> CronTime conversion
public extension Date {
    
    /// Represent date instance as a CronTime struct
    var asCronTime: CronTime {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        return try! CronTime(hours: .init(hour), minutes: .init(minutes))
    }
    
}
