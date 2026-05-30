import Foundation
import Entity
import Repository

public protocol ProductUseCaseProtocol {
    func fetchAll(params: ProductSearchParams) async throws -> [ProductEntity]
    func fetchByID(_ id: Int) async throws -> ProductEntity
}

public struct ProductUseCase: ProductUseCaseProtocol {

    private let repository: ProductRepositoryProtocol

    public init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
    }

    public func fetchAll(params: ProductSearchParams = ProductSearchParams()) async throws -> [ProductEntity] {
        try await repository.fetchAll(params: params)
    }

    public func fetchByID(_ id: Int) async throws -> ProductEntity {
        try await repository.fetchByID(id)
    }
}
