//
//  QuestionDetail.swift
//
//
//  Created by Vadim Marchenko on 18.03.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Core
import Domain

@Reducer
public struct QuestionDetail {

    // MARK: - Properties
    @Dependency(\.questionClient) var client
    @Dependency(\.dismiss) var dismiss
    private enum CancelID { case client }
    private let logger = ComistLogger.questionDetailPresentation

    // MARK: - Init
    public init() {}

    // MARK: - State
    @ObservableState
    public struct State {
        public init(identifier: UUID,
                    title: String = "") {
            self.identifier = identifier
            self.title = title
        }
        let title: String
        let identifier: UUID
        var selectedIndex = 0
        var question: Question?

        @Presents var alert: AlertState<Action.Alert>?
        @Presents var addArgument: CreateArgument.State?
    }

    // MARK: - Action
    public enum Action {
        case initialAction
        case segmentTapped(Int)
        case dismiss
        case processResponse(Result<Question, Error>)
        case alert(PresentationAction<Alert>)
        case addArgument(PresentationAction<CreateArgument.Action>)
        case addArgumentTapped
        case itemDeleted(IndexSet)

        public enum Alert: Equatable {
            case dismissing
        }
    }

    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialAction:
                return .run { [state] send in
                    await send(.processResponse(Result { try await client.fetchItem(state.identifier) }))
                }
            case .segmentTapped(let index):
                state.selectedIndex = index
                return .none
            case .alert(.presented(.dismissing)):
                state.alert = nil
                return .send(.dismiss)
            case .dismiss:
                return .run { _ in
                    await dismiss()
                }
            case .processResponse(let response):
                switch response {
                case .success(let question):
                    state.question = question
                    return .none
                case .failure:
                    state.alert = AlertState {
                        TextState("Opps...")
                    } actions: {
                        ButtonState(role: .cancel, action: .dismissing) {
                            TextState("Ok")
                        }
                    } message: {
                        TextState("Could not fetch item")
                    }
                    return .none
                }
            case .alert:
                return .none
            case .addArgument(.presented(.saved)):
                return .send(.initialAction)
            case .addArgument:
                return .none
            case .addArgumentTapped:
                state.addArgument = CreateArgument.State(questionIdentifier: state.identifier)
                return .none
            case .itemDeleted(let indexSet):
                let questionIdentifier = state.identifier
                return .run { [state] send in
                    for index in indexSet {
                        do {
                            if let argument = state.question?.arguments[index] {
                                try await client.deleteArgument(questionIdentifier, argument.id)
                            }
                        } catch let error {
                            logger.error("\(error)")
                        }
                    }
                    await send(.initialAction)
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$addArgument, action: \.addArgument) {
            CreateArgument()
        }
    }

}
