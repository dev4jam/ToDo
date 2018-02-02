//
//  Date.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import Foundation

public extension Date {
    public var timestamp: String {
        return String(format: "%.0f", timeIntervalSince1970 * 1000)
    }

    public var timestampInt: Int {
        return Int(round(timeIntervalSince1970 * 1000))
    }
}
