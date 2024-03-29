//
//  CommistLogger.swift
//
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation
import OSLog

public typealias ComistLogger = Logger

extension Logger {

    enum LogCategory: String {
        case localStorage
        case repository
        case questionListPresentation
        case questionDetailPresentation
        case createQuestionPresentation
        case createArgumentPresentation

        func callAsFunction() -> String {
            self.rawValue
        }
    }

    private static var bundleIdentifier: String {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("No bundle identifier was found")
        }
        return bundleIdentifier
    }

    public static let localStorage = Logger.with(category: LogCategory.localStorage)
    public static let repository = Logger.with(category: .repository)
    public static let questionListPresentation = Logger.with(category: .questionListPresentation)
    public static let questionDetailPresentation = Logger.with(category: .questionDetailPresentation)
    public static let createQuestionPresentation = Logger.with(category: .createQuestionPresentation)
    public static let createArgumentPresentation = Logger.with(category: .createArgumentPresentation)
}

extension Logger {

    static func with(category: LogCategory) -> Logger {
        return Logger(subsystem: bundleIdentifier, category: category())
    }
}
