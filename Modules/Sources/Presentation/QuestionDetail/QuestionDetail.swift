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

@Reducer
public struct QuestionDetail {
    
    // MARK: - Properties
    @Dependency(\.questionClient) var client
    private enum CancelID { case client }
    private let logger = ComistLogger.questionDetailPresentation
    
    // MARK: - Init
    public init() { }
    
    // MARK: - State
    @ObservableState
    public struct State {
        public init() { }
    }
    
    // MARK: - Action
    public enum Action {
        case initialAction
    }
    
    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialAction:
                return .none
            }
        }
    }
    
}
