import Testing
import Foundation
@testable import Repository
@testable import Entity

@Suite("MockData integrity")
struct MockDataTests {

    @Test("PastaMockData has unique pastaIDs")
    func pastaIDsAreUnique() {
        let ids = PastaMockData.all.map(\.pastaID)
        #expect(Set(ids).count == ids.count)
    }

    @Test("PastaMockData imageNames match expected pattern")
    func pastaImageNames() {
        for (index, pasta) in PastaMockData.all.enumerated() {
            let expected = "Pasta/pasta_\(String(format: "%02d", index + 1))"
            #expect(pasta.imageName == expected)
        }
    }

    @Test("PastaMockData has non-empty descriptions")
    func pastaDescriptionsNonEmpty() {
        for pasta in PastaMockData.all {
            #expect(!pasta.catchCopy.isEmpty)
            #expect(!pasta.descriptionText.isEmpty)
            #expect(!pasta.category.isEmpty)
        }
    }

    @Test("TapasMockData has unique tapasIDs")
    func tapasIDsAreUnique() {
        let ids = TapasMockData.all.map(\.tapasID)
        #expect(Set(ids).count == ids.count)
    }

    @Test("TapasMockData imageNames match expected pattern")
    func tapasImageNames() {
        for (index, tapas) in TapasMockData.all.enumerated() {
            let expected = "Tapas/tapas_\(String(format: "%02d", index + 1))"
            #expect(tapas.imageName == expected)
        }
    }

    @Test("TapasMockData has non-empty region and authorName")
    func tapasMetadata() {
        for tapas in TapasMockData.all {
            #expect(!tapas.region.isEmpty)
            #expect(!tapas.authorName.isEmpty)
            #expect(!tapas.postedAt.isEmpty)
        }
    }
}
