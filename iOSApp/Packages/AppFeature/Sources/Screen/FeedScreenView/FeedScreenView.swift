import SwiftUI
import Entity
import ViewStateProvider
import LocalStorage

public struct FeedScreenView: View {

    @State private var stateProvider = FeedViewStateProvider()
    @State private var selectedFeatured: FeaturedEntity?
    @State private var selectedProduct: ProductEntity?
    @Namespace private var heroNamespace
    @Namespace private var productNamespace

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: []) {
                        FeaturedCarouselSection(
                            items: stateProvider.featuredList,
                            namespace: heroNamespace,
                            onTap: { selectedFeatured = $0 }
                        )
                        NewsSection(items: stateProvider.newsList)
                        ProductGridSection(
                            items: stateProvider.productList,
                            namespace: productNamespace,
                            onTap: { selectedProduct = $0 }
                        )
                    }
                }
                .scrollIndicators(.hidden)

                if let featured = selectedFeatured {
                    FeaturedDetailOverlay(
                        item: featured,
                        namespace: heroNamespace,
                        onClose: { withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { selectedFeatured = nil } }
                    )
                    .zIndex(10)
                    .transition(.opacity)
                }

                if let product = selectedProduct {
                    ProductDetailOverlay(
                        item: product,
                        namespace: productNamespace,
                        onClose: { withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { selectedProduct = nil } }
                    )
                    .zIndex(10)
                    .transition(.opacity)
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { await stateProvider.fetchAll() }
    }
}

// MARK: - FeaturedCarouselSection

private struct FeaturedCarouselSection: View {
    let items: [FeaturedEntity]
    let namespace: Namespace.ID
    let onTap: (FeaturedEntity) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("おすすめレストラン")
                .font(.title2.bold())
                .padding(.horizontal, 16)
                .padding(.top, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        FeaturedCard(item: item, namespace: namespace)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                    onTap(item)
                                }
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 24)
    }
}

private struct FeaturedCard: View {
    let item: FeaturedEntity
    let namespace: Namespace.ID

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(item.imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 260, height: 180)
                .clipped()
                .matchedGeometryEffect(id: "featured-image-\(item.id)", in: namespace)

            LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .frame(width: 260, height: 180)
                .matchedGeometryEffect(id: "featured-gradient-\(item.id)", in: namespace)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.category)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))
                    .matchedGeometryEffect(id: "featured-category-\(item.id)", in: namespace)
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .matchedGeometryEffect(id: "featured-title-\(item.id)", in: namespace)
            }
            .padding(12)
        }
        .frame(width: 260, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
    }
}

// MARK: - FeaturedDetailOverlay

private struct FeaturedDetailOverlay: View {
    let item: FeaturedEntity
    let namespace: Namespace.ID
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    Image(item.imageName, bundle: .module)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 320)
                        .clipped()
                        .matchedGeometryEffect(id: "featured-image-\(item.id)", in: namespace)

                    LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                        .frame(maxWidth: .infinity)
                        .frame(height: 320)
                        .matchedGeometryEffect(id: "featured-gradient-\(item.id)", in: namespace)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.category)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.8))
                            .matchedGeometryEffect(id: "featured-category-\(item.id)", in: namespace)
                        Text(item.title)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .matchedGeometryEffect(id: "featured-title-\(item.id)", in: namespace)
                    }
                    .padding(20)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text(item.catchCopy)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(item.descriptionText)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    StarRatingRow(rating: item.rating)
                }
                .padding(20)
                .background(Color(.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)
            .padding(.top, 100)
            .shadow(color: .black.opacity(0.3), radius: 20)

            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .shadow(radius: 4)
            }
            .padding(.top, 56)
            .padding(.leading, 20)
        }
    }
}

private struct StarRatingRow: View {
    let rating: Float

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { i in
                Image(systemName: Float(i) < rating ? "star.fill" : "star")
                    .foregroundStyle(.yellow)
                    .font(.caption)
            }
            Text(String(format: "%.1f", rating))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - NewsSection

private struct NewsSection: View {
    let items: [NewsEntity]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("グルメニュース")
                .font(.title2.bold())
                .padding(.horizontal, 16)

            ForEach(items.prefix(6)) { item in
                NewsRow(item: item)
            }
        }
        .padding(.bottom, 24)
    }
}

private struct NewsRow: View {
    let item: NewsEntity

    var body: some View {
        HStack(spacing: 12) {
            Image(item.imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.category)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
                Text(item.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                Text(item.descriptionText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

// MARK: - ProductGridSection

private struct ProductGridSection: View {
    let items: [ProductEntity]
    let namespace: Namespace.ID
    let onTap: (ProductEntity) -> Void
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("おすすめ商品")
                .font(.title2.bold())
                .padding(.horizontal, 16)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items.prefix(8)) { item in
                    ProductCard(item: item, namespace: namespace)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                onTap(item)
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 32)
    }
}

private struct ProductCard: View {
    let item: ProductEntity
    let namespace: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(item.imageName, bundle: .module)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 130)
                    .clipped()
                    .matchedGeometryEffect(id: "product-image-\(item.id)", in: namespace)

                if item.isSale {
                    Text("\(item.percentSale)%OFF")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(6)
                }
                if item.isPremium {
                    Image(systemName: "crown.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .matchedGeometryEffect(id: "product-name-\(item.id)", in: namespace)

                if item.isSale {
                    HStack(spacing: 4) {
                        Text("¥\(item.discountedPrice)")
                            .font(.caption.bold())
                            .foregroundStyle(.orange)
                            .matchedGeometryEffect(id: "product-price-\(item.id)", in: namespace)
                        Text("¥\(item.regularPrice)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .strikethrough()
                    }
                } else {
                    Text("¥\(item.regularPrice)")
                        .font(.caption.bold())
                        .foregroundStyle(.primary)
                        .matchedGeometryEffect(id: "product-price-\(item.id)", in: namespace)
                }
            }
            .padding(8)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
    }
}

// MARK: - ProductDetailOverlay

private struct ProductDetailOverlay: View {
    let item: ProductEntity
    let namespace: Namespace.ID
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(alignment: .leading, spacing: 0) {
                Image(item.imageName, bundle: .module)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    .clipped()
                    .matchedGeometryEffect(id: "product-image-\(item.id)", in: namespace)

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(item.productName)
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .matchedGeometryEffect(id: "product-name-\(item.id)", in: namespace)
                        Spacer()
                        if item.isSale {
                            Text("¥\(item.discountedPrice)")
                                .font(.headline.bold())
                                .foregroundStyle(.orange)
                                .matchedGeometryEffect(id: "product-price-\(item.id)", in: namespace)
                        } else {
                            Text("¥\(item.regularPrice)")
                                .font(.headline.bold())
                                .foregroundStyle(.primary)
                                .matchedGeometryEffect(id: "product-price-\(item.id)", in: namespace)
                        }
                    }
                    Text(item.productSummary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(item.productDescription)
                        .font(.body)
                        .foregroundStyle(.primary)
                    FlowLayout(tags: item.productHashtags)
                }
                .padding(20)
                .background(Color(.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)
            .padding(.top, 80)
            .shadow(color: .black.opacity(0.3), radius: 20)

            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .shadow(radius: 4)
            }
            .padding(.top, 56)
            .padding(.leading, 20)
        }
    }
}

private struct FlowLayout: View {
    let tags: [String]

    var body: some View {
        FlexibleTagLayout(tags: tags)
    }
}

private struct FlexibleTagLayout: View {
    let tags: [String]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
    }
}

// MARK: - Preview

#Preview {
    FeedScreenView()
}
