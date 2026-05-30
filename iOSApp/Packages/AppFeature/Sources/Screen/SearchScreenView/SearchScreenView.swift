import SwiftUI
import Entity
import ViewStateProvider

public struct SearchScreenView: View {

    @State private var stateProvider = SearchViewStateProvider()
    @State private var showFilters = false
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                filterChips
                resultContent
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilters.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterSheetView(stateProvider: stateProvider) {
                    showFilters = false
                    Task { await stateProvider.search() }
                }
            }
        }
        .task { await stateProvider.search() }
    }

    // MARK: - SubViews

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("料理・食材・ジャンルを検索", text: $stateProvider.keyword)
                .onSubmit {
                    Task { await stateProvider.search() }
                }
            if !stateProvider.keyword.isEmpty {
                Button {
                    stateProvider.keyword = ""
                    Task { await stateProvider.search() }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(stateProvider.mainCategories, id: \.self) { cat in
                    CategoryChip(
                        title: cat,
                        isSelected: stateProvider.selectedMainCategory == cat
                    ) {
                        if stateProvider.selectedMainCategory == cat {
                            stateProvider.selectedMainCategory = nil
                        } else {
                            stateProvider.selectedMainCategory = cat
                            stateProvider.selectedSubCategory = nil
                        }
                        Task { await stateProvider.search() }
                    }
                }
                if stateProvider.isPremiumOnly || stateProvider.isSaleOnly {
                    if stateProvider.isPremiumOnly {
                        CategoryChip(title: "プレミアム", isSelected: true) {
                            stateProvider.isPremiumOnly = false
                            Task { await stateProvider.search() }
                        }
                    }
                    if stateProvider.isSaleOnly {
                        CategoryChip(title: "セール中", isSelected: true) {
                            stateProvider.isSaleOnly = false
                            Task { await stateProvider.search() }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }

    private var resultContent: some View {
        Group {
            if stateProvider.requestState == .requesting {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if stateProvider.results.isEmpty {
                emptyState
            } else {
                resultGrid
            }
        }
    }

    private var resultGrid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(stateProvider.results.count)件の商品")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(stateProvider.results) { item in
                        SearchResultCard(item: item)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("検索結果が見つかりませんでした")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("キーワードやフィルターを変えてお試しください")
                .font(.caption)
                .foregroundStyle(.secondary)
            Button("フィルターをリセット") {
                stateProvider.resetFilters()
                Task { await stateProvider.search() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - CategoryChip

private struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.orange : Color(.secondarySystemBackground))
                .clipShape(Capsule())
        }
    }
}

// MARK: - SearchResultCard

private struct SearchResultCard: View {
    let item: ProductEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(item.imageName, bundle: .module)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .clipped()

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
                        .padding(6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName)
                    .font(.caption.weight(.semibold))
                    .lineLimit(2)
                Text(item.productMainCategory)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                if item.isSale {
                    HStack(spacing: 3) {
                        Text("¥\(item.discountedPrice)")
                            .font(.caption.bold())
                            .foregroundStyle(.orange)
                        Text("¥\(item.regularPrice)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .strikethrough()
                    }
                } else {
                    Text("¥\(item.regularPrice)")
                        .font(.caption.bold())
                }
            }
            .padding(8)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 5, y: 2)
    }
}

// MARK: - FilterSheetView

private struct FilterSheetView: View {
    @Bindable var stateProvider: SearchViewStateProvider
    let onApply: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("サブカテゴリ") {
                    if let mainCat = stateProvider.selectedMainCategory,
                       let subs = stateProvider.subCategories[mainCat] {
                        Picker("サブカテゴリ", selection: $stateProvider.selectedSubCategory) {
                            Text("すべて").tag(String?.none)
                            ForEach(subs, id: \.self) { sub in
                                Text(sub).tag(Optional(sub))
                            }
                        }
                    } else {
                        Text("メインカテゴリを選択してください")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }

                Section("価格帯") {
                    HStack {
                        Text("最低価格: ¥\(stateProvider.minPrice)")
                        Spacer()
                        Slider(value: Binding(
                            get: { Double(stateProvider.minPrice) },
                            set: { stateProvider.minPrice = Int($0) }
                        ), in: 0...10000, step: 100)
                        .frame(width: 150)
                    }
                    HStack {
                        Text("最高価格: ¥\(stateProvider.maxPrice)")
                        Spacer()
                        Slider(value: Binding(
                            get: { Double(stateProvider.maxPrice) },
                            set: { stateProvider.maxPrice = Int($0) }
                        ), in: 0...10000, step: 100)
                        .frame(width: 150)
                    }
                }

                Section("絞り込み") {
                    Toggle("プレミアム商品のみ", isOn: $stateProvider.isPremiumOnly)
                    Toggle("セール中のみ", isOn: $stateProvider.isSaleOnly)
                }

                Section("並び替え") {
                    Picker("並び替え", selection: $stateProvider.sortBy) {
                        Text("新着順").tag("newest")
                        Text("価格の安い順").tag("price_asc")
                        Text("価格の高い順").tag("price_desc")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("フィルター")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("リセット") {
                        stateProvider.resetFilters()
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("適用") {
                        onApply()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SearchScreenView()
}
