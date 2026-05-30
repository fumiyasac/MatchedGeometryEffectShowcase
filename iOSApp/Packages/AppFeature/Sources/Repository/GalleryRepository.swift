import Foundation
import Entity
import Infrastructure

public protocol GalleryRepositoryProtocol {
    func fetchAll() async throws -> [GalleryPhotoEntity]
    func fetchByID(_ id: Int) async throws -> GalleryPhotoEntity
}

public struct GalleryRepository: GalleryRepositoryProtocol {

    private let apiClient: ApiClientManager

    public init(apiClient: ApiClientManager = .shared) {
        self.apiClient = apiClient
    }

    public func fetchAll() async throws -> [GalleryPhotoEntity] {
        let responses = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.galleryPhotos.url,
            responseFormat: [GalleryPhotoResponse].self
        )
        return responses.map { $0.toEntity() }
    }

    public func fetchByID(_ id: Int) async throws -> GalleryPhotoEntity {
        let response = try await apiClient.executeAPIRequest(
            endpointUrl: APIEndpoint.galleryPhoto(id: id).url,
            responseFormat: GalleryPhotoResponse.self
        )
        return response.toEntity()
    }
}
