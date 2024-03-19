//
//  CreateQuestion.swift
//
//
//  Created by Vadim Marchenko on 19.03.2024.
//

import Foundation
import ComposableArchitecture
import Domain
import Core

@Reducer
public struct CreateQuestion {

    // MARK: Properties
    @Dependency(\.questionClient) var client
    @Dependency(\.dismiss) var dismiss
    private let logger = ComistLogger.createQuestionPresentation

    // MARK: Init
    public init() {}

    // MARK: State
    @ObservableState
    public struct State {
        var title: String = ""
        var subtitle: String = ""
        var question: Question?
    }

    // MARK: Action
    public enum Action {
        case titleChanged(String?)
        case subtitle(String?)
        case saveTapped
        case questionSaved(Question)
    }

    // MARK: Reducer
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .titleChanged(let title):
                state.title = title ?? ""
                return .none
            case .subtitle(let subtitle):
                state.subtitle = subtitle ?? ""
                return .none
            case .saveTapped:
                let question = Question(title: state.title,
                                        subtitle: state.subtitle,
                                        arguments: [])
                state.question = question
                return .run { send in

                    // TODO: Add error hanlidng
                    do {
                        try await client.insert(question)
                    } catch let error {
                        logger.error("\(error)")
                    }
                    await send(.questionSaved(question))
                }
            case .questionSaved:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}
