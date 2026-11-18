import Foundation
import Entity
import Repository

public protocol PastaUseCaseProtocol: Sendable {
    func fetchAll() async throws -> [PastaEntity]
    func fetchByID(_ id: Int) async throws -> PastaEntity
}

public struct PastaUseCase: PastaUseCaseProtocol {

    private let repository: PastaRepositoryProtocol

    public init(repository: PastaRepositoryProtocol = PastaRepository()) {
        self.repository = repository
    }

    public func fetchAll() async throws -> [PastaEntity] {
        try await repository.fetchAll()
    }

    public func fetchByID(_ id: Int) async throws -> PastaEntity {
        try await repository.fetchByID(id)
    }
}
