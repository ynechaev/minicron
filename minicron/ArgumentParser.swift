//
//  ArgumentParser.swift
//  minicron
//
//  Created by Yuri Nechaev on 06.11.2022.
//

import Foundation

final class ArgumentParser {

    // parse arguments & drop first one since it's a path
    static func parseArgument(at index: Int) -> String? {
        let args = Array(CommandLine.arguments.dropFirst())
        return args.indices.contains(index) ? args[index] : nil
    }
    
}


