//
//  QuestionMapper.swift
//  
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation
import Data

extension Question {
    func mapToData() -> QuestionEntity {
        QuestionEntity(identifier: self.identifier,
                       title: self.title,
                       subtitle: self.subtitle,
                       arguments: self.arguments.map { $0.mapToData()})
    }
}

extension QuestionEntity {
    func mapToDomain() -> Question {
        Question(identifier: self.identifier,
                 title: self.title,
                 subtitle: self.subtitle,
                 arguments: self.arguments.map { $0.mapToDomain() })
    }
}
