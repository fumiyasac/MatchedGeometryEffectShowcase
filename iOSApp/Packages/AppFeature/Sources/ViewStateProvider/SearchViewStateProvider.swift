import Foundation
import Entity
import Infrastructure
import UseCase
import Repository
import LocalStorage

@Observable
public final class SearchViewStateProvider {

    public var keyword: String = ""
    public var selectedMainCategory: String? = nil
    public var selectedSubCategory: String? = nil
    public var minPrice: Int = 0
    public var maxPrice: Int = 10000
    public var isPremiumOnly: Bool = false
    public var isSaleOnly: Bool = false
    public var sortBy: String = "newest"

    public var results: [ProductEntity] = []
    public var requestState: APIRequestState = .none
    public var errorMessage: String?

    public let mainCategories = ["和食", "洋食", "アジア", "スイーツ", "カフェ"]
    public let subCategories: [String: [String]] = [
        "和食":   ["カレー", "海鮮", "懐石", "鍋料理", "ラーメン", "揚げ物", "野菜", "調味料"],
        "洋食":   ["フレンチ", "イタリアン", "グリル", "グラタン", "パスタ", "スペイン料理", "肉料理"],
        "アジア":  ["カレー", "タイ料理", "ベトナム料理", "麺料理"],
        "スイーツ": ["和スイーツ", "焼き菓子", "抹茶スイーツ", "チョコレート", "ビーガン", "スナック", "ヘルシーおやつ", "保存食"],
        "カフェ":  ["朝食"],
    ]
    public let sortOptions = ["newest", "price_asc", "price_desc", "rating"]

    private let productUseCase: ProductUseCaseProtocol

    public init(productUseCase: ProductUseCaseProtocol = ProductUseCase()) {
        self.productUseCase = productUseCase
    }

    @MainActor
    public func search() async {
        requestState = .requesting
        let params = ProductSearchParams(
            keyword: keyword.isEmpty ? nil : keyword,
            mainCategory: selectedMainCategory,
            subCategory: selectedSubCategory,
            minPrice: minPrice > 0 ? minPrice : nil,
            maxPrice: maxPrice < 10000 ? maxPrice : nil,
            isPremium: isPremiumOnly ? true : nil,
            isSale: isSaleOnly ? true : nil,
            sortBy: sortBy
        )
        do {
            results = try await productUseCase.fetchAll(params: params)
            requestState = .success
        } catch {
            errorMessage = error.localizedDescription
            requestState = .error
            results = filterMockData(params: params)
        }
    }

    public func resetFilters() {
        keyword = ""
        selectedMainCategory = nil
        selectedSubCategory = nil
        minPrice = 0
        maxPrice = 10000
        isPremiumOnly = false
        isSaleOnly = false
        sortBy = "newest"
    }

    private func filterMockData(params: ProductSearchParams) -> [ProductEntity] {
        var items = LocalMockDataProvider.products()
        if let kw = params.keyword, !kw.isEmpty {
            items = items.filter { $0.productName.contains(kw) || $0.productSummary.contains(kw) }
        }
        if let cat = params.mainCategory { items = items.filter { $0.productMainCategory == cat } }
        if let sub = params.subCategory { items = items.filter { $0.productSubCategory == sub } }
        if let min = params.minPrice { items = items.filter { $0.regularPrice >= min } }
        if let max = params.maxPrice { items = items.filter { $0.regularPrice <= max } }
        if params.isPremium == true { items = items.filter { $0.isPremium } }
        if params.isSale == true { items = items.filter { $0.isSale } }
        return items
    }
}
