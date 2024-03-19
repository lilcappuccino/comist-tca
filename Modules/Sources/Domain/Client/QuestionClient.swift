//
//  QuestionClient.swift
//
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation
import ComposableArchitecture
import Data

@DependencyClient
public struct QuestionClient {
    public var fetchItem: @Sendable (UUID) async throws -> Question
    public var fetch: @Sendable () async throws -> [Question]
    public var insert: @Sendable (Question) async throws -> Void
    public var delete: @Sendable (UUID) async throws -> Void
}

extension DependencyValues {
    public var questionClient: QuestionClient {
        get { self[QuestionClient.self] }
        set { self[QuestionClient.self] = newValue }
    }
}

extension QuestionClient: DependencyKey, TestDependencyKey {
    public static var liveValue: QuestionClient {
        let repository = QuestionRepository(localStorage: LocalStorageImpl())
        return QuestionClient(fetchItem: repository.fetchQuestion(by: ),
                              fetch: repository.fetchQuestions,
                              insert: repository.insert,
                              delete: repository.delete(by: ))
    }

    public static var previewValue: QuestionClient {
        let repository = QuestionRepositoryMock()
        return QuestionClient(fetchItem: repository.fetchQuestion,
                              fetch: repository.fetchQuestions,
                              insert: repository.insert,
                              delete: repository.delete(by:))
    }

    public static var testValue: QuestionClient {
        let repository = QuestionRepositoryMock()
        return QuestionClient(fetchItem: repository.fetchQuestion,
                              fetch: repository.fetchQuestions,
                              insert: repository.insert,
                              delete: repository.delete(by:))
    }
}
