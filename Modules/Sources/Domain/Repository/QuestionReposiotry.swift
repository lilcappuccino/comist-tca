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
    
    @Sendable func fetchQuestions() async throws -> [Question] {
        logger.info("Executing \(#function)")
        return try await localStorage.fetchQuestions().map { $0.mapToDomain() }
    }
    
    @Sendable func insert() async throws {
        let question = Question(title: "Do i have to bought a psp", subtitle: "I would like to play fifa", arguments: [.init(title: "I lile it", value: 6, position: .cons),
                                                                                                                        .init(title: "A lot of time", value: 3, position: .pros)])
        return try await localStorage.insert(question: question.mapToData())
    }
    
    @Sendable public func delete(by identifier: UUID) async throws {
        return try await localStorage.delete(by: identifier)
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
    
    @Sendable func insert() async {}
    
    @Sendable func delete(by identifier: UUID) async {}
}
