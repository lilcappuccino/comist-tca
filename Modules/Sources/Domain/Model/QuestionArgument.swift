//
//  QuestionArgument.swift
//  
//
//  Created by Vadim Marchenko on 11.03.2024.
//

import Foundation

public struct QuestionArgument: Identifiable {
  public let id: UUID
  public let title: String
  public let value: Int
  public let position: ArgumentPosition

  public init(id: UUID = UUID(), title: String, value: Int, position: ArgumentPosition) {
        self.id = id
        self.title = title
        self.value = value
        self.position = position
    }
}
