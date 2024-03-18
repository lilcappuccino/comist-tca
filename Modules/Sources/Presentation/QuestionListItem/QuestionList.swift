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
        var questions: [QuestionListModel] = []
    }
    
    // MARK: - Action
    public enum Action {
        case initialAction
        case processResponse(Result<[Question], Error>)
        case errrorAppeared(Error)
        case itemDeleted(IndexSet)
        case itemAdded
    }
    
    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialAction:
                return .run { send in
                    await send(.processResponse(Result { try await client.fetch() }))
                }.cancellable(id: CancelID.client)
            case .processResponse(let result):
                switch result {
                case .success(let questions):
                    state.questions = questions.map { QuestionListModel(identifier: $0.identifier,
                                                                        title: $0.title,
                                                                        state: $0.state) }
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
            case .itemAdded:
                return .run { send in
                    do {
                        try await client.insert()
                    } catch let error {
                        await send(.errrorAppeared(error))
                    }
                    await send(.processResponse(Result { try await client.fetch() }))
                }
            case .errrorAppeared(let error):
                logger.error("\(error.localizedDescription)")
                // TODO: Error handling will be here
                return .none
            }
        }
    }
    
}
