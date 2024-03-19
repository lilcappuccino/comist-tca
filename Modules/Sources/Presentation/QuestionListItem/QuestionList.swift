//
//  QuestionList.swift
//
//
//  Created by Vadim Marchenko on 11.03.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Domain
import Core

@Reducer
public struct QuestionList {

    // MARK: - Properties
    @Dependency(\.questionClient) var client
    private enum CancelID { case client }
    private let logger = ComistLogger.questionListPresentation

    // MARK: - Init
    public init() { }

    // MARK: - State
    @ObservableState
    public struct State {

        public init() { }
        var path = StackState<Path.State>()
        var questions: [QuestionListModel] = []
        @Presents var addQuestion: CreateQuestion.State?
    }

    // MARK: - Action
    public enum Action {
        case didAppear
        case processResponse(Result<[Question], Error>)
        case errrorAppeared(Error)
        case itemDeleted(IndexSet)
        case openItemTapped(QuestionListModel)
        case path(StackAction<Path.State, Path.Action>)
        case addQuestion(PresentationAction<CreateQuestion.Action>)
        case addQuestionTapped
    }

    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                return .run { send in
                    await send(.processResponse(Result { try await client.fetch() }))
                }.cancellable(id: CancelID.client)
            case .processResponse(let result):
                switch result {
                case .success(let questions):
                    state.questions = questions.map { QuestionListModel(identifier: $0.identifier,
                                                                        title: $0.title,
                                                                        position: $0.state) }
                    return .none
                case .failure(let error):
                    return .send(.errrorAppeared(error))
                }
            case .itemDeleted(let identifier):
                return .run { [state] send in
                    for index in identifier {
                        let item = state.questions[index]
                        do {
                            try await client.delete(item.identifier)
                        } catch let error {
                            await send(.errrorAppeared(error))
                        }
                    }
                    await send(.processResponse(Result { try await client.fetch() }))
                }.cancellable(id: CancelID.client)
            case .errrorAppeared(let error):
                logger.error("\(error.localizedDescription)")
                // TODO: Error handling will be here
                return .none
            case .path:
                return .none
            case .openItemTapped(let model):
                state.path.append(.detail(QuestionDetail.State(identifier: model.identifier,
                                                               title: model.title)))
                return .none
            case .addQuestionTapped:
                state.addQuestion = CreateQuestion.State()
                return .none
            case .addQuestion(.presented(.questionSaved(let question))):
                state.path.append(.detail(QuestionDetail.State(identifier: question.identifier,
                                                               title: question.title)))
                return .none
            case .addQuestion:
                return .none
            }
        }
        .ifLet(\.$addQuestion, action: \.addQuestion) {
            CreateQuestion()
        }
        .forEach(\.path, action: \.path) {
            Path()
        }

    }

    // MARK: - Navigation
    // swiftlint:disable nesting
    @Reducer
    public struct Path {

        @ObservableState
        public enum State {
            case detail(QuestionDetail.State)
        }

        public enum Action {
            case openDetail(QuestionDetail.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.openDetail) {
                QuestionDetail()
            }

        }
    }
    // swiftlint:enable nesting
}
