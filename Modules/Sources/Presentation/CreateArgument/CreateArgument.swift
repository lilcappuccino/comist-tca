//
//  CreateArgument.swift
//
//
//  Created by Vadim Marchenko on 18.03.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Domain
import Core

@Reducer
public struct CreateArgument {

    // MARK: Properties
    @Dependency(\.questionClient) var client
    let logger = ComistLogger.createArgumentPresentation
    @Dependency(\.dismiss) var dismiss

    // MARK: Init
    public init() {}

    // MARK: State
    @ObservableState
    public struct State {
        init(questionIdentifier: UUID) {
            self.questionIdentifier = questionIdentifier
        }

        let questionIdentifier: UUID
        var position: ArgumentPosition = .pros
        var priority: FibonacciPriority = .low
        var title: String = ""
    }

    // MARK: Action
    public enum Action {
        case priorityChanged(FibonacciPriority)
        case positionChanged(ArgumentPosition)
        case nameChanged(String)
        case saveTapped
        case saved
    }

    // MARK: Reducer
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .priorityChanged(let priority):
                state.priority = priority
                return .none
            case .positionChanged(let position):
                state.position = position
                return .none
            case .nameChanged(let title):
                state.title = title
                return .none
            case .saveTapped:
                let argument = QuestionArgument(title: state.title,
                                                value: state.priority(),
                                                position: state.position)
                let identifier = state.questionIdentifier
                return .run { send in
                    do {
                        try await client.insertArgument(identifier, argument)
                    } catch let error {
                        logger.error("\(error)")
                    }
                    await send(.saved)
                }
            case .saved:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}
