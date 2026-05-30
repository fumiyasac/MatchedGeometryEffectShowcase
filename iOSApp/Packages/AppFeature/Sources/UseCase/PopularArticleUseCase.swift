import Foundation
import Entity
import Repository

public protocol PopularArticleUseCaseProtocol {
    func fetchAll() async throws -> [PopularArticleEntity]
    func fetchByID(_ id: Int) async throws -> PopularArticleEntity
}

public struct PopularArticleUseCase: PopularArticleUseCaseProtocol {

    private let repository: PopularArticleRepositoryProtocol

    public init(repository: PopularArticleRepositoryProtocol = PopularArticleRepository()) {
        self.repository = repository
    }

    public func fetchAll() async throws -> [PopularArticleEntity] {
        try await repository.fetchAll()
    }

    public func fetchByID(_ id: Int) async throws -> PopularArticleEntity {
        try await repository.fetchByID(id)
    }
}
