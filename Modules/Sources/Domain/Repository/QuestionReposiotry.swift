//
//  QuestionReposiotry.swift
//
//
//  Created by Vadim Marchenko on 11.03.2024.
//

import Foundation
import Data
import Core

final class QuestionRepository {

    // TODO: Network storage will be added.
    private var localStorage: LocalStorage
    private var logger = ComistLogger.repository

    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }

    @Sendable func fetchQuestion(by identifier: UUID) async throws -> Question {
        logger.info("Executing \(#function)")
        return try await localStorage.fetchQuestions(by: identifier).mapToDomain()
    }

    @Sendable func fetchQuestions() async throws -> [Question] {
        logger.info("Executing \(#function)")
        return try await localStorage.fetchQuestions().map { $0.mapToDomain() }
    }

    @Sendable func insert(question: Question) async throws {
        return try await localStorage.insert(question: question.mapToData())
    }

    @Sendable public func delete(by identifier: UUID) async throws {
        return try await localStorage.delete(by: identifier)
    }

    @Sendable func insertArgument(by questionIdentifier: UUID, argument: QuestionArgument) async throws {
        try await localStorage.insertArgument(by: questionIdentifier, argument: argument.mapToData())
    }

    @Sendable func deleteArgument(by questionIdentifier: UUID, argumentIdentifier: UUID) async throws {
        try await localStorage.deleteArgument(by: questionIdentifier, argumentIdentifier: argumentIdentifier)
    }

}

// MARK: - Mock
final class QuestionRepositoryMock {
    @Sendable func fetchQuestions() async throws -> [Question] {
        return [Question(title: "New ps5",
                         subtitle: "Should I buy a new ps5",
                         arguments: [
                            QuestionArgument(title: "I like fifa", value: 5, position: .cons),
                            QuestionArgument(title: "I like fifa", value: 5, position: .pros)
                         ])]
    }

    @Sendable func fetchQuestion(by identifier: UUID) async throws -> Question {
        return Question(title: "New ps5",
                        subtitle: "Should I buy a new ps5",
                        arguments: [
                            QuestionArgument(title: "I like fifa", value: 5, position: .cons),
                            QuestionArgument(title: "I like fifa", value: 5, position: .pros)
                        ])
    }

    @Sendable func insertArgument(by questionIdentifier: UUID, argument: QuestionArgument) async throws {}

    @Sendable func insert(question: Question) async {}

    @Sendable func delete(by identifier: UUID) async {}

    @Sendable func deleteArgument(by questionIdentifier: UUID, argumentIdentifier: UUID) async throws {}
}
