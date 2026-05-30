import Testing
import Foundation
@testable import LocalStorage
@testable import Entity

@Suite("LocalMockDataProvider")
struct LocalMockDataProviderTests {

    @Test("galleryPhotos returns 20 items")
    func galleryPhotosCount() {
        let photos = LocalMockDataProvider.galleryPhotos()
        #expect(photos.count == 20)
    }

    @Test("galleryPhotos have correct imageName format")
    func galleryPhotosImageNames() {
        let photos = LocalMockDataProvider.galleryPhotos()
        for (index, photo) in photos.enumerated() {
            #expect(photo.imageName == "Gallery/image\(index + 1)")
        }
    }

    @Test("galleryPhotos IDs are sequential from 1")
    func galleryPhotosIDs() {
        let photos = LocalMockDataProvider.galleryPhotos()
        for (index, photo) in photos.enumerated() {
            #expect(photo.galleryPhotoID == index + 1)
        }
    }

    @Test("pickupFoods returns 24 items")
    func pickupFoodsCount() {
        let foods = LocalMockDataProvider.pickupFoods()
        #expect(foods.count == 24)
    }

    @Test("pickupFoods have Sample imageName prefix")
    func pickupFoodsImageNames() {
        let foods = LocalMockDataProvider.pickupFoods()
        for food in foods {
            #expect(food.imageName.hasPrefix("Sample/sample"))
        }
    }

    @Test("popularArticles returns 12 items")
    func popularArticlesCount() {
        let articles = LocalMockDataProvider.popularArticles()
        #expect(articles.count == 12)
    }

    @Test("popularArticles have non-empty hashtags")
    func popularArticlesHashtags() {
        let articles = LocalMockDataProvider.popularArticles()
        for article in articles {
            #expect(!article.articleHashtags.isEmpty)
        }
    }

    @Test("featured returns 4 items")
    func featuredCount() {
        let featured = LocalMockDataProvider.featured()
        #expect(featured.count == 4)
    }

    @Test("featured ratings are between 0 and 5")
    func featuredRatings() {
        let featured = LocalMockDataProvider.featured()
        for item in featured {
            #expect(item.rating >= 0 && item.rating <= 5)
        }
    }

    @Test("news returns 12 items")
    func newsCount() {
        let news = LocalMockDataProvider.news()
        #expect(news.count == 12)
    }

    @Test("products returns 20 items")
    func productsCount() {
        let products = LocalMockDataProvider.products()
        #expect(products.count == 20)
    }

    @Test("products with isSale have percentSale > 0")
    func productsSaleConsistency() {
        let products = LocalMockDataProvider.products()
        let saleProducts = products.filter { $0.isSale }
        for product in saleProducts {
            #expect(product.percentSale > 0)
            #expect(product.discountedPrice < product.regularPrice)
        }
    }

    @Test("products non-sale items have discountedPrice equal to regularPrice")
    func productsNonSalePriceConsistency() {
        let products = LocalMockDataProvider.products()
        let nonSaleProducts = products.filter { !$0.isSale }
        for product in nonSaleProducts {
            #expect(product.discountedPrice == product.regularPrice)
        }
    }

    @Test("all entities have non-empty titles")
    func allEntitiesHaveNonEmptyTitles() {
        let photos = LocalMockDataProvider.galleryPhotos()
        let foods = LocalMockDataProvider.pickupFoods()
        let articles = LocalMockDataProvider.popularArticles()
        let products = LocalMockDataProvider.products()

        photos.forEach { #expect(!$0.title.isEmpty) }
        foods.forEach { #expect(!$0.title.isEmpty) }
        articles.forEach { #expect(!$0.articleTitle.isEmpty) }
        products.forEach { #expect(!$0.productName.isEmpty) }
    }
}
