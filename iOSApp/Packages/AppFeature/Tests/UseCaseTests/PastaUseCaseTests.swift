import Testing
import Foundation
@testable import UseCase
@testable import Entity
@testable import Repository

// MARK: - Mock Repository

final class MockPastaRepository: PastaRepositoryProtocol, @unchecked Sendable {

    var stubbedPastas: [PastaEntity] = []
    var stubbedPasta: PastaEntity?
    var shouldThrow = false

    func fetchAll() async throws -> [PastaEntity] {
        if shouldThrow { throw PastaTestError.mock }
        return stubbedPastas
    }

    func fetchByID(_ id: Int) async throws -> PastaEntity {
        if shouldThrow { throw PastaTestError.mock }
        guard let pasta = stubbedPasta else { throw PastaTestError.notFound }
        return pasta
    }
}

enum PastaTestError: Error {
    case mock, notFound
}

// MARK: - Tests

@Suite("PastaUseCase")
struct PastaUseCaseTests {

    private func makePasta(id: Int) -> PastaEntity {
        PastaEntity(
            pastaID: id,
            title: "テストパスタ \(id)",
            category: "クリーム",
            catchCopy: "キャッチコピー",
            descriptionText: "説明文",
            imageName: "Pasta/pasta_\(String(format: "%02d", id))"
        )
    }

    @Test("fetchAll returns pastas from repository")
    func fetchAllReturnsPastas() async throws {
        let mock = MockPastaRepository()
        mock.stubbedPastas = (1...5).map { makePasta(id: $0) }
        let useCase = PastaUseCase(repository: mock)

        let result = try await useCase.fetchAll()

        #expect(result.count == 5)
        #expect(result.first?.pastaID == 1)
        #expect(result.last?.pastaID == 5)
    }

    @Test("fetchAll returns empty array when repository is empty")
    func fetchAllReturnsEmpty() async throws {
        let mock = MockPastaRepository()
        mock.stubbedPastas = []
        let useCase = PastaUseCase(repository: mock)

        let result = try await useCase.fetchAll()
        #expect(result.isEmpty)
    }

    @Test("fetchAll propagates repository error")
    func fetchAllThrowsOnError() async {
        let mock = MockPastaRepository()
        mock.shouldThrow = true
        let useCase = PastaUseCase(repository: mock)

        await #expect(throws: PastaTestError.mock) {
            try await useCase.fetchAll()
        }
    }

    @Test("fetchByID returns correct pasta")
    func fetchByIDReturnsPasta() async throws {
        let mock = MockPastaRepository()
        let expected = makePasta(id: 7)
        mock.stubbedPasta = expected
        let useCase = PastaUseCase(repository: mock)

        let result = try await useCase.fetchByID(7)

        #expect(result.pastaID == 7)
        #expect(result.category == "クリーム")
        #expect(result.imageName == "Pasta/pasta_07")
    }

    @Test("fetchByID throws when not found")
    func fetchByIDThrowsWhenNotFound() async {
        let mock = MockPastaRepository()
        mock.stubbedPasta = nil
        let useCase = PastaUseCase(repository: mock)

        await #expect(throws: PastaTestError.notFound) {
            try await useCase.fetchByID(99)
        }
    }

    @Test("PastaMockData.all returns 24 items matching IDs 1...24")
    func mockDataIntegrity() {
        let all = PastaMockData.all
        #expect(all.count == 24)
        for (index, pasta) in all.enumerated() {
            #expect(pasta.pastaID == index + 1)
            #expect(!pasta.title.isEmpty)
            #expect(pasta.imageName.hasPrefix("Pasta/pasta_"))
        }
    }
}
