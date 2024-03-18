//
//  Question.swift
//
//
//  Created by Vadim Marchenko on 08.03.2024.
//

import Foundation

public enum QuestionState {
    case cons
    case pros
    case unowned
}

public struct Question {
    public let identifier: UUID
    public let title: String
    public let subtitle: String?
    public let arguments: [QuestionArgument]
    
    // Helpers
    public var prosArguments: [QuestionArgument] {
        arguments.filter { $0.position == .pros}
    }
    
    public var consArguments: [QuestionArgument] {
        arguments.filter { $0.position == .cons}
    }
    
    public var prosArgumentsValue: Int {
        prosArguments.reduce(0) { sum, argument in
            sum + argument.value
        }
    }
    
    public var consArgumentsValue: Int {
        consArguments.reduce(0) { sum, argument in
            sum + argument.value
        }
    }
    
    public var state: QuestionState {
        if prosArgumentsValue > consArgumentsValue {
            return .pros
        } else if prosArgumentsValue < consArgumentsValue {
            return .cons
        } else {
            return .unowned
        }
    }
    
    public init(identifier: UUID = UUID(), title: String, subtitle: String?, arguments: [QuestionArgument]) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.arguments = arguments
    }
}
