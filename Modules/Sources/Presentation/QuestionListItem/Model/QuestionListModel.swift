//
//  QuestionListModel.swift
//
//
//  Created by Vadim Marchenko on 14.03.2024.
//

import Foundation
import Domain

typealias QuestionPositionModel = ArgumentPosition
public struct QuestionListModel {
    let identifier: UUID
    let title: String
    let position: QuestionPositionModel
}
