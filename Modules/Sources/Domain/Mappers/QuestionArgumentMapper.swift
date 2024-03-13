//
//  QuestionArgumentMapper.swift
//  
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation
import Data

extension QuestionArgument {
    func mapToData() -> QuestionArgumentEntity {
        return QuestionArgumentEntity(title: self.title,
                                      value: self.value,
                                      position: self.position.mapToData())
    }
}

extension QuestionArgumentEntity {
    func mapToDomain() -> QuestionArgument {
        QuestionArgument(title: self.title,
                         value: self.value,
                         position: self.position.mapToDomain())
    }
}
