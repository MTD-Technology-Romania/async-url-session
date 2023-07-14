//
//  Logger.swift
//  AsyncSession
//
//  Created by Daniel Mandea on 14.07.2023.
//

import Foundation
import os.log

extension Logger {
    /// Logs the view cycles like viewDidLoad.
    static let sdk = Logger(subsystem: "Async Session", category: "sdk")
}
