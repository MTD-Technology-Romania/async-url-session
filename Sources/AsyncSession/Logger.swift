//
//  Logger.swift
//  AsyncSession
//
//  Created by Daniel Mandea on 14.07.2023.
//

import Foundation
import os.log

/// A simple logging utility for displaying messages at different log levels.
public struct Logger {
    /// Enumeration representing different log levels.
    ///
    /// - error: Indicates an error log level.
    /// - warning: Indicates a warning log level.
    /// - info: Indicates an informational log level.
    public enum LogLevel: String {
        case error
        case warning
        case info
    }


    /// The minimum log level for messages to be printed.
    ///
    /// Set this property to control the verbosity of logs. Messages below this level won't be logged.
    public static var logLevel: LogLevel = .error

    /// Log a message at the specified log level.
    ///
    /// - Parameters:
    ///   - level: The log level of the message.
    ///   - message: The message to be logged.
    private static func log(_ level: LogLevel, _ message: String) {
        if level.rawValue.compare(Logger.logLevel.rawValue) == .orderedDescending {
            // This log level is below the configured threshold, so we don't log this message.
            return
        }

        let formattedMessage = "[\(level.rawValue.uppercased())] \(message)"
        print(formattedMessage)
    }
}

public extension Logger {
    /// Log an error message with details.
    ///
    /// Example usage:
    ///
    ///     Logger.error("This is an error message.", details: "Additional details about the error.")
    ///
    /// - Parameters:
    ///   - message: The error message to be logged.
    ///   - details: Additional details about the error.
    static func error(_ message: String, details: String) {
        log(.error, "\(message) - Details: \(details)")
    }

    /// Log a warning message with details.
    ///
    /// Example usage:
    ///
    ///     Logger.warning("This is a warning message.", details: "Additional details about the warning.")
    ///
    /// - Parameters:
    ///   - message: The warning message to be logged.
    ///   - details: Additional details about the warning.
    static func warning(_ message: String, details: String) {
        log(.warning, "\(message) - Details: \(details)")
    }

    /// Log an informational message with details.
    ///
    /// Example usage:
    ///
    ///     Logger.info("This is an informational message.", details: "Additional details.")
    ///
    /// - Parameters:
    ///   - message: The informational message to be logged.
    ///   - details: Additional details.
    static func info(_ message: String, details: String) {
        log(.info, "\(message) - Details: \(details)")
    }
}
