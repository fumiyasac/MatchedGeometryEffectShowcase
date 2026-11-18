import Foundation
import Entity
import Repository

public protocol TapasUseCaseProtocol: Sendable {
    func fetchAll() async throws -> [TapasEntity]
    func fetchByID(_ id: Int) async throws -> TapasEntity
}

public struct TapasUseCase: TapasUseCaseProtocol {

    private let repository: TapasRepositoryProtocol

    public init(repository: TapasRepositoryProtocol = TapasRepository()) {
        self.repository = repository
    }

    public func fetchAll() async throws -> [TapasEntity] {
        try await repository.fetchAll()
    }

    public func fetchByID(_ id: Int) async throws -> TapasEntity {
        try await repository.fetchByID(id)
    }
}
