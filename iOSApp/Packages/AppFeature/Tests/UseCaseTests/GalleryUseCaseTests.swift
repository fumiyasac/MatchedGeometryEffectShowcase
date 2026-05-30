import Testing
import Foundation
@testable import UseCase
@testable import Entity
@testable import Repository

// MARK: - Mock Repository

final class MockGalleryRepository: GalleryRepositoryProtocol {

    var stubbedPhotos: [GalleryPhotoEntity] = []
    var stubbedPhoto: GalleryPhotoEntity?
    var shouldThrow = false

    func fetchAll() async throws -> [GalleryPhotoEntity] {
        if shouldThrow { throw TestError.mock }
        return stubbedPhotos
    }

    func fetchByID(_ id: Int) async throws -> GalleryPhotoEntity {
        if shouldThrow { throw TestError.mock }
        guard let photo = stubbedPhoto else { throw TestError.notFound }
        return photo
    }
}

enum TestError: Error {
    case mock, notFound
}

// MARK: - Tests

@Suite("GalleryUseCase")
struct GalleryUseCaseTests {

    private func makePhoto(id: Int) -> GalleryPhotoEntity {
        GalleryPhotoEntity(
            galleryPhotoID: id,
            category: "和食",
            title: "テスト料理 \(id)",
            catchCopy: "キャッチコピー",
            descriptionText: "説明文",
            imageName: "Gallery/image\(id)"
        )
    }

    @Test("fetchAll returns photos from repository")
    func fetchAllReturnsPhotos() async throws {
        let mock = MockGalleryRepository()
        mock.stubbedPhotos = (1...5).map { makePhoto(id: $0) }
        let useCase = GalleryUseCase(repository: mock)

        let result = try await useCase.fetchAll()

        #expect(result.count == 5)
        #expect(result.first?.galleryPhotoID == 1)
        #expect(result.last?.galleryPhotoID == 5)
    }

    @Test("fetchAll returns empty array when repository is empty")
    func fetchAllReturnsEmpty() async throws {
        let mock = MockGalleryRepository()
        mock.stubbedPhotos = []
        let useCase = GalleryUseCase(repository: mock)

        let result = try await useCase.fetchAll()

        #expect(result.isEmpty)
    }

    @Test("fetchAll propagates repository error")
    func fetchAllThrowsOnError() async {
        let mock = MockGalleryRepository()
        mock.shouldThrow = true
        let useCase = GalleryUseCase(repository: mock)

        await #expect(throws: TestError.mock) {
            try await useCase.fetchAll()
        }
    }

    @Test("fetchByID returns correct photo")
    func fetchByIDReturnsPhoto() async throws {
        let mock = MockGalleryRepository()
        let expected = makePhoto(id: 7)
        mock.stubbedPhoto = expected
        let useCase = GalleryUseCase(repository: mock)

        let result = try await useCase.fetchByID(7)

        #expect(result.galleryPhotoID == 7)
        #expect(result.category == "和食")
        #expect(result.imageName == "Gallery/image7")
    }

    @Test("fetchByID throws when not found")
    func fetchByIDThrowsWhenNotFound() async {
        let mock = MockGalleryRepository()
        mock.stubbedPhoto = nil
        let useCase = GalleryUseCase(repository: mock)

        await #expect(throws: TestError.notFound) {
            try await useCase.fetchByID(99)
        }
    }
}
