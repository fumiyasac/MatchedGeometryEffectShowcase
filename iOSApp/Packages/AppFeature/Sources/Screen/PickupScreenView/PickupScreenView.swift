import SwiftUI
import Entity
import ViewStateProvider

public struct PickupScreenView: View {

    @State private var stateProvider = PickupViewStateProvider()
    @Namespace private var zoomNamespace

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: mosaicColumns(), spacing: 0) {
                    ForEach(Array(stateProvider.pickupList.enumerated()), id: \.offset) { index, item in
                        NavigationLink {
                            PickupDetailView(item: item)
                                .navigationTransition(.zoom(sourceID: item.id, in: zoomNamespace))
                        } label: {
                            PickupPhotoTile(item: item, index: index)
                                .matchedTransitionSource(id: item.id, in: zoomNamespace)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Pickup")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { await stateProvider.fetchAll() }
    }

    private func mosaicColumns() -> [GridItem] {
        [
            GridItem(.flexible(), spacing: 2),
            GridItem(.flexible(), spacing: 2),
            GridItem(.flexible(), spacing: 2),
        ]
    }
}

// MARK: - PickupPhotoTile

private struct PickupPhotoTile: View {
    let item: PickupPhotoEntity
    let index: Int

    private var isLarge: Bool {
        (index % 7) == 0 || (index % 7) == 3
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Image(item.imageName, bundle: .module)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: isLarge ? 200 : 120)
                    .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.5)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: isLarge ? 200 : 120)

                Text(item.title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .padding(6)
            }
            .frame(width: geo.size.width, height: isLarge ? 200 : 120)
        }
        .frame(height: isLarge ? 200 : 120)
    }
}

// MARK: - PickupDetailView

private struct PickupDetailView: View {
    let item: PickupPhotoEntity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(item.imageName, bundle: .module)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 360)
                    .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    Text(item.title)
                        .font(.title2.bold())

                    Text("旬の食材を使ったこちらの料理は、地元の農家から直送される新鮮な素材で作られています。シェフが丁寧に仕上げた一品をぜひお楽しみください。")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    HStack {
                        Label("地産地消", systemImage: "leaf.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                        Label("今週のPickup", systemImage: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
                .padding(20)
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    PickupScreenView()
}
