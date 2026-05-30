import Foundation
import SwiftData

@Observable
public final class FavoritesManager {

    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func add(_ item: FavoriteItem) {
        modelContext.insert(item)
        try? modelContext.save()
    }

    public func remove(itemID: Int, itemType: FavoriteItemType) {
        let type = itemType.rawValue
        let descriptor = FetchDescriptor<FavoriteItem>(
            predicate: #Predicate { $0.itemID == itemID && $0.itemType == type }
        )
        guard let existing = try? modelContext.fetch(descriptor).first else { return }
        modelContext.delete(existing)
        try? modelContext.save()
    }

    public func isFavorite(itemID: Int, itemType: FavoriteItemType) -> Bool {
        let type = itemType.rawValue
        let descriptor = FetchDescriptor<FavoriteItem>(
            predicate: #Predicate { $0.itemID == itemID && $0.itemType == type }
        )
        return (try? modelContext.fetch(descriptor).first) != nil
    }

    public func fetchAll() -> [FavoriteItem] {
        let descriptor = FetchDescriptor<FavoriteItem>(sortBy: [SortDescriptor(\.addedAt, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
