//
//  LocalStorage.swift
//
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation
import SwiftData
import Core


enum LocalStorageError: Error {
    case couldNotFetch
    case couldNotDelete
    case couldNotInsert
    
    var description: String {
        switch self {
        case .couldNotFetch:
            "error-fetch"
        case .couldNotDelete:
            "error-delete"
        case .couldNotInsert:
            "error-insert"
        }
    }
}

public protocol LocalStorage: AnyObject {
    func fetchQuestions() async throws -> [QuestionEntity]
    func insert(question: QuestionEntity) async throws
    func delete(by identifier: UUID) async throws
}

public actor LocalStorageImpl: LocalStorage {
    
    private let logger = ComistLogger.localStorage
    private var modelContainer = try? ModelContainer(for: QuestionEntity.self)
    
    public init() { }
    
    @MainActor @Sendable public func fetchQuestions() async throws -> [QuestionEntity] {
        guard let container = await  modelContainer else {
            fatalError("Could not extract model container")
        }
        let descriptor = FetchDescriptor<QuestionEntity>()
        do {
            let models =  try container.mainContext.fetch(descriptor)
            logger.info("fetched questions: \(models.count)")
            return models
        } catch let error {
            logger.error("\(error.localizedDescription)")
            throw LocalStorageError.couldNotFetch
        }
    }
    
    @MainActor public func insert(question: QuestionEntity) async throws {
        guard let container = await modelContainer else {
            fatalError("Could not extract model container")
        }
        container.mainContext.insert(question)
        do {
            try container.mainContext.save()
        } catch let error {
            logger.error("\(error.localizedDescription)")
            throw LocalStorageError.couldNotInsert
        }
    }
    
    @MainActor public func delete(by identifier: UUID) async throws {
        guard let container = await modelContainer else {
            fatalError("Could not extract model container")
        }
        do {
            try container.mainContext.delete(model: QuestionEntity.self, where: #Predicate { $0.identifier == identifier })
        } catch let error {
            logger.error("\(error.localizedDescription)")
            throw LocalStorageError.couldNotDelete
        }
    }
}

