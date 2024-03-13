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

@Reducer
public struct QuestionList {
    
    @Dependency(\.questionClient) var client
    private enum CancelID { case client }
    
    public init() { }
    
    @ObservableState
    public struct State {
        
        public init() { }
        
        var questions: [Question] = []
    }
    
    public enum Action {
        case initialAction
        case fetchingResponse(Result<[Question], Error>)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialAction:
                return .run { send in
                    await try? client.insert()
                    await send(.fetchingResponse(Result { try await client.fetch() }))
                }.cancellable(id: CancelID.client)
            case .fetchingResponse(let result):
                switch result {
                case .success(let questions):
                    state.questions = questions
                case .failure(let  error):
                    return .none
                }
            }
            return .none
        }
    }
}
