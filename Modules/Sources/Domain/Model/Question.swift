//
//  Question.swift
//
//
//  Created by Vadim Marchenko on 08.03.2024.
//

import Foundation

struct Question {
    let title: String
    let subtitle: String
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
    
    var isPros: Bool {
        prosArgumentsValue > consArgumentsValue
    }
}


