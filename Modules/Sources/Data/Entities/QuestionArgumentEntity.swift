//
//  QuestionArgumentEntity.swift
//
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation

public class QuestionArgumentEntity: Codable {
    public var id: UUID
    public var title: String
    public var value: Int
    public var position: ArgumentPositionEntity

    public init(id: UUID, title: String, value: Int, position: ArgumentPositionEntity) {
        self.id = id
        self.title = title
        self.value = value
        self.position = position
    }
}
