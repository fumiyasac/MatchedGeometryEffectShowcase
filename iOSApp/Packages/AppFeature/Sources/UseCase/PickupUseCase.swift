import Foundation
import Entity
import Repository

public protocol PickupUseCaseProtocol {
    func fetchAll() async throws -> [PickupPhotoEntity]
}

public struct PickupUseCase: PickupUseCaseProtocol {

    private let repository: PickupRepositoryProtocol

    public init(repository: PickupRepositoryProtocol = PickupRepository()) {
        self.repository = repository
    }

    public func fetchAll() async throws -> [PickupPhotoEntity] {
        try await repository.fetchAll()
    }
}
