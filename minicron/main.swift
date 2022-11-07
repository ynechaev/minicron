//
//  main.swift
//  minicron
//
//  Created by Yuri Nechaev on 25.10.2022.
//

// CLI wrapper for minicron-framework
// Workflow:
//      CLI        |            minicron-framework           |        CLI
// [parse input] ----> [create model] ----> [build output] ----> [print output]
//
// Call format:
//
// <input> minicron <simulated_time?>
// where:
// input - STDIN stream
// simulated_time - Optional parameter of simulated current time, format hh:mm
//
// Input format: see minicron-framework

import Foundation
import minicron_framework

// task config storage
var jobs = [CronJob]()

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
            jobs.append(config)
        } catch {
            print(error)
            exit(1)
        }
    }
}

// build next task trigger schedule
func buildSchedule() -> [String] {
    return jobs.compactMap { job in
        return [job.time.nextTrigger(against: simulatedTime).rawValue,
                job.task].joined(separator: " - ")
    }
}

func main() {
    configure()
    readInput()
    let schedule = buildSchedule()
    schedule.forEach({ print($0) })
}

main()
