//
//  Question.swift
//
//
//  Created by Vadim Marchenko on 08.03.2024.
//

import Foundation

enum QuestionState {
    case cons
    case pros
    case unowned
}

public struct Question {
    let identifier: UUID
    let title: String
    let subtitle: String?
    let arguments: [QuestionArgument]
    
    // Helpers
    var prosArguments: [QuestionArgument] {
        arguments.filter { $0.position == .pros}
    }
    
    var consArguments: [QuestionArgument] {
        arguments.filter { $0.position == .cons}
    }
    
    var prosArgumentsValue: Int {
        prosArguments.reduce(0) { sum, argument in
            sum + argument.value
        }
    }
    
    var consArgumentsValue: Int {
        consArguments.reduce(0) { sum, argument in
            sum + argument.value
        }
    }
    
    var state: QuestionState {
        if prosArgumentsValue > consArgumentsValue {
            return .pros
        } else if prosArgumentsValue < consArgumentsValue {
            return .cons
        } else {
            return .unowned
        }
    }
    
    init(identifier: UUID = UUID(), title: String, subtitle: String?, arguments: [QuestionArgument]) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.arguments = arguments
    }
}
