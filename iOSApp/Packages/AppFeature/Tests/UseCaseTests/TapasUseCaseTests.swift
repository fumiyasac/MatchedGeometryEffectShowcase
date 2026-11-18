import Testing
import Foundation
@testable import UseCase
@testable import Entity
@testable import Repository

// MARK: - Mock Repository

final class MockTapasRepository: TapasRepositoryProtocol, @unchecked Sendable {

    var stubbedTapas: [TapasEntity] = []
    var stubbedTapasItem: TapasEntity?
    var shouldThrow = false

    func fetchAll() async throws -> [TapasEntity] {
        if shouldThrow { throw TapasTestError.mock }
        return stubbedTapas
    }

    func fetchByID(_ id: Int) async throws -> TapasEntity {
        if shouldThrow { throw TapasTestError.mock }
        guard let tapas = stubbedTapasItem else { throw TapasTestError.notFound }
        return tapas
    }
}

enum TapasTestError: Error {
    case mock, notFound
}

// MARK: - Tests

@Suite("TapasUseCase")
struct TapasUseCaseTests {

    private func makeTapas(id: Int) -> TapasEntity {
        TapasEntity(
            tapasID: id,
            title: "テストタパス \(id)",
            region: "Barcelona",
            postedAt: "2026-11-18 10:00",
            authorName: "Chef Test",
            catchCopy: "キャッチコピー",
            descriptionText: "説明文",
            imageName: "Tapas/tapas_\(String(format: "%02d", id))"
        )
    }

    @Test("fetchAll returns tapas from repository")
    func fetchAllReturnsTapas() async throws {
        let mock = MockTapasRepository()
        mock.stubbedTapas = (1...3).map { makeTapas(id: $0) }
        let useCase = TapasUseCase(repository: mock)

        let result = try await useCase.fetchAll()

        #expect(result.count == 3)
        #expect(result.first?.tapasID == 1)
    }

    @Test("fetchAll propagates repository error")
    func fetchAllThrowsOnError() async {
        let mock = MockTapasRepository()
        mock.shouldThrow = true
        let useCase = TapasUseCase(repository: mock)

        await #expect(throws: TapasTestError.mock) {
            try await useCase.fetchAll()
        }
    }

    @Test("fetchByID returns correct tapas")
    func fetchByIDReturnsTapas() async throws {
        let mock = MockTapasRepository()
        let expected = makeTapas(id: 5)
        mock.stubbedTapasItem = expected
        let useCase = TapasUseCase(repository: mock)

        let result = try await useCase.fetchByID(5)

        #expect(result.tapasID == 5)
        #expect(result.region == "Barcelona")
        #expect(result.imageName == "Tapas/tapas_05")
    }

    @Test("fetchByID throws when not found")
    func fetchByIDThrowsWhenNotFound() async {
        let mock = MockTapasRepository()
        mock.stubbedTapasItem = nil
        let useCase = TapasUseCase(repository: mock)

        await #expect(throws: TapasTestError.notFound) {
            try await useCase.fetchByID(99)
        }
    }

    @Test("TapasMockData.all returns 10 items matching IDs 1...10")
    func mockDataIntegrity() {
        let all = TapasMockData.all
        #expect(all.count == 10)
        for (index, tapas) in all.enumerated() {
            #expect(tapas.tapasID == index + 1)
            #expect(!tapas.title.isEmpty)
            #expect(!tapas.region.isEmpty)
            #expect(tapas.imageName.hasPrefix("Tapas/tapas_"))
        }
    }
}
