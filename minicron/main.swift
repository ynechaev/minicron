//
//  main.swift
//  minicron
//
//  Created by Yuri Nechaev on 25.10.2022.
//

import Foundation
import minicron_framework

// task config storage
var configs = [CronJob]()

// passed simulated time with a fallback to current time
var simulatedTime: CronTime = Date().asCronTime

// configure with passed arguments
func configure() {
    if let timeArg = ArgumentParser.parseArgument(at: 0) {
        if let time = CronTime(rawValue: timeArg) {
            simulatedTime = time
        }
    }
}

// read stdin
func readInput() {
    while let line = readLine() {
        do {
            let config = try CronJob(line: line)
            configs.append(config)
        } catch {
            print(error)
            exit(1)
        }
    }
}

// build next task trigger schedule
func buildSchedule() -> [String] {
    return configs.compactMap { config in
        return [config.time.nextTrigger(against: simulatedTime).rawValue,
                config.task].joined(separator: " - ")
    }
}

func main() {
    configure()
    readInput()
    let schedule = buildSchedule()
    schedule.forEach({ print($0) })
}

main()
