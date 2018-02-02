//
//  Config.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import Foundation

struct Config {
    let maxIncompleteItems: Int

    var appVersion: String {
        var defaultVersion = "1.0"

        if let dictionary = Bundle.main.infoDictionary {
            if let version = dictionary["CFBundleShortVersionString"] as? String {
                defaultVersion = version
            }
        }

        return defaultVersion
    }

    var buildNumber: String {
        var defaultNumber = "1"

        if let dictionary = Bundle.main.infoDictionary {
            if let build = dictionary["CFBundleVersion"] as? String {
                defaultNumber = build
            }
        }

        return defaultNumber
    }
}
