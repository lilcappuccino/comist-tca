//
//  LocalStorage.swift
//
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation
import SwiftData
import Core

// MARK: - LocalStorageError
enum LocalStorageError: Error {
    case couldNotFetch
    case couldNotDelete
    case couldNotInsert
    case doesNotExist
    case couldNotAddArgument

    var description: String {
        switch self {
        case .couldNotFetch:
            return "error-fetch"
        case .couldNotDelete:
            return "error-delete"
        case .couldNotInsert:
            return "error-insert"
        case .doesNotExist:
            return "error-does-not-exist"
        case .couldNotAddArgument:
            return ""
        }
    }
}

// MARK: - LocalStorage
public protocol LocalStorage: AnyObject {
    func fetchQuestions() async throws -> [QuestionEntity]
    func insert(question: QuestionEntity) async throws
    func delete(by identifier: UUID) async throws
    func fetchQuestions(by identifier: UUID) async throws -> QuestionEntity
    func insertArgument(by questionIdentifier: UUID, argument: QuestionArgumentEntity) async throws
    func deleteArgument(by questionIdentifier: UUID, argumentIdentifier: UUID) async throws
}

// MARK: - LocalStorageImpl
public actor LocalStorageImpl: LocalStorage {

    private let logger = ComistLogger.localStorage
    private var modelContainer = try? ModelContainer(for: QuestionEntity.self)

    public init() { }

    @MainActor public func fetchQuestions(by identifier: UUID) async throws -> QuestionEntity {
        guard let container = await  modelContainer else {
            fatalError("Could not extract model container")
        }
        let descriptor = FetchDescriptor<QuestionEntity>(predicate: #Predicate { $0.identifier == identifier })
        do {
            guard let model = try container.mainContext.fetch(descriptor).first else {
                throw LocalStorageError.doesNotExist
            }
            logger.info("fetched question: \(model.title)")
            return model
        } catch let error {
            logger.error("\(error.localizedDescription)")
            throw LocalStorageError.couldNotFetch
        }
    }

    @MainActor public func fetchQuestions() async throws -> [QuestionEntity] {
        guard let container = await  modelContainer else {
            fatalError("Could not extract model container")
        }
        let descriptor = FetchDescriptor<QuestionEntity>()
        do {
            let models = try container.mainContext.fetch(descriptor)
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

    @MainActor public func insertArgument(by questionIdentifier: UUID, argument: QuestionArgumentEntity) async throws {
        guard let container = await  modelContainer else {
            fatalError("Could not extract model container")
        }
        let descriptor = FetchDescriptor<QuestionEntity>(predicate: #Predicate { $0.identifier == questionIdentifier })
        do {
            guard let model = try container.mainContext.fetch(descriptor).first else {
                throw LocalStorageError.doesNotExist
            }
            model.arguments.append(argument)
            try container.mainContext.save()
        } catch let error {
            logger.error("\(error.localizedDescription)")
            throw LocalStorageError.couldNotAddArgument
        }
    }

    @MainActor public func deleteArgument(by questionIdentifier: UUID, argumentIdentifier: UUID) async throws {
        guard let container = await  modelContainer else {
            fatalError("Could not extract model container")
        }
        let descriptor = FetchDescriptor<QuestionEntity>(predicate: #Predicate { $0.identifier == questionIdentifier })
        do {
            guard let model = try container.mainContext.fetch(descriptor).first else {
                throw LocalStorageError.doesNotExist
            }
            model.arguments.removeAll(where: { $0.id == argumentIdentifier })
            try container.mainContext.save()
        } catch let error {
            logger.error("\(error.localizedDescription)")
            throw LocalStorageError.couldNotAddArgument
        }
    }
}
