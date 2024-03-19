//
//  QuestionEntity.swift
//
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation
import SwiftData

@Model
public class QuestionEntity {
    public var identifier: UUID
    public var date: Date = Date.now
    public var title: String
    public var subtitle: String?
    public var arguments: [QuestionArgumentEntity]

    public init(identifier: UUID = UUID(), title: String, subtitle: String? = nil, arguments: [QuestionArgumentEntity]) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.arguments = arguments
    }
}
