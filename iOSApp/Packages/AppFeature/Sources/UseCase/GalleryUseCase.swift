import Foundation
import Entity
import Repository

public protocol GalleryUseCaseProtocol {
    func fetchAll() async throws -> [GalleryPhotoEntity]
    func fetchByID(_ id: Int) async throws -> GalleryPhotoEntity
}

public struct GalleryUseCase: GalleryUseCaseProtocol {

    private let repository: GalleryRepositoryProtocol

    public init(repository: GalleryRepositoryProtocol = GalleryRepository()) {
        self.repository = repository
    }

    public func fetchAll() async throws -> [GalleryPhotoEntity] {
        try await repository.fetchAll()
    }

    public func fetchByID(_ id: Int) async throws -> GalleryPhotoEntity {
        try await repository.fetchByID(id)
    }
}
