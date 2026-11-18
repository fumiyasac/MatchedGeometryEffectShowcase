import SwiftUI
import Entity
import ViewStateProvider

// MARK: - SwiftUI製 Tapas Timeline (.matchedTransitionSource + .navigationTransition(.zoom))

public struct TapasTimelineScreenView: View {

    @State private var stateProvider = TapasStateProvider()
    @Namespace private var tapasNamespace

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(stateProvider.tapasList) { tapas in
                        NavigationLink {
                            TapasDetailView(tapas: tapas)
                                .navigationTransition(.zoom(sourceID: tapas.id, in: tapasNamespace))
                        } label: {
                            TapasTimelineCard(tapas: tapas)
                                .matchedTransitionSource(id: tapas.id, in: tapasNamespace)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tapas Timeline")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { await stateProvider.fetchAll() }
    }
}

// MARK: - TapasTimelineCard

struct TapasTimelineCard: View {

    let tapas: TapasEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ヘッダー（投稿者情報）
            HStack(spacing: 10) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(tapas.authorName.prefix(1)))
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(tapas.authorName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text(tapas.region)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Text(tapas.postedAt.suffix(5))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // メイン画像
            Image(tapas.imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .clipped()

            // キャプション
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    Image(systemName: "heart")
                        .font(.title3)
                    Image(systemName: "bubble.right")
                        .font(.title3)
                    Image(systemName: "paperplane")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "bookmark")
                        .font(.title3)
                }
                .foregroundStyle(.primary)

                Text(tapas.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(tapas.catchCopy)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

// MARK: - TapasDetailView

struct TapasDetailView: View {

    let tapas: TapasEntity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(tapas.imageName, bundle: .module)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 380)
                    .clipped()

                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)
                            .overlay(
                                Text(String(tapas.authorName.prefix(1)))
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tapas.authorName)
                                .font(.headline)
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundStyle(.orange)
                                Text(tapas.region)
                                Text("・")
                                Text(tapas.postedAt)
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }

                    Text(tapas.title)
                        .font(.title.bold())

                    Text(tapas.catchCopy)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Divider()

                    Text(tapas.descriptionText)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundStyle(.primary)

                    HStack(spacing: 24) {
                        Label("128", systemImage: "heart.fill")
                            .foregroundStyle(.pink)
                        Label("12", systemImage: "bubble.right.fill")
                            .foregroundStyle(.blue)
                    }
                    .font(.subheadline.weight(.semibold))
                    .padding(.top, 8)
                }
                .padding(20)
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview("Timeline") {
    TapasTimelineScreenView()
}

#Preview("Timeline Card") {
    TapasTimelineCard(
        tapas: TapasEntity(
            tapasID: 1,
            title: "トマト ブルスケッタ",
            region: "Barcelona",
            postedAt: "2026-11-18 09:12",
            authorName: "Chef Alvaro",
            catchCopy: "カリッと焼いたバゲットに溢れるフレッシュトマト",
            descriptionText: "説明文",
            imageName: "Tapas/tapas_01"
        )
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("Detail") {
    NavigationStack {
        TapasDetailView(
            tapas: TapasEntity(
                tapasID: 1,
                title: "トマト ブルスケッタ",
                region: "Barcelona",
                postedAt: "2026-11-18 09:12",
                authorName: "Chef Alvaro",
                catchCopy: "カリッと焼いたバゲットに溢れるフレッシュトマト",
                descriptionText: "完熟トマトをダイスにし、ニンニクとバジルを和えて厚切りバゲットにたっぷりと。",
                imageName: "Tapas/tapas_01"
            )
        )
    }
}
