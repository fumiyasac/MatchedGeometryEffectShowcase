import SwiftUI
import Entity
import ViewStateProvider

// MARK: - SwiftUI製 3列グリッド + matchedGeometryEffect による詳細遷移

public struct PastaGridScreenView: View {

    @State private var stateProvider = PastaStateProvider()
    @State private var selected: PastaEntity?
    @Namespace private var pastaNamespace

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 6), count: 3)

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 6) {
                        ForEach(stateProvider.pastaList) { pasta in
                            PastaGridCard(
                                pasta: pasta,
                                namespace: pastaNamespace,
                                isSource: selected?.id != pasta.id
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.48, dampingFraction: 0.82)) {
                                    selected = pasta
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)

                if let pasta = selected {
                    PastaGridDetailOverlay(
                        pasta: pasta,
                        namespace: pastaNamespace,
                        onClose: {
                            withAnimation(.spring(response: 0.48, dampingFraction: 0.82)) {
                                selected = nil
                            }
                        }
                    )
                    .zIndex(10)
                }
            }
            .navigationTitle("Pasta Grid")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { await stateProvider.fetchAll() }
    }
}

// MARK: - PastaGridCard

struct PastaGridCard: View {

    let pasta: PastaEntity
    let namespace: Namespace.ID
    let isSource: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(pasta.imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .clipped()
                .matchedGeometryEffect(id: "pasta-image-\(pasta.id)", in: namespace, isSource: isSource)

            LinearGradient(
                colors: [.clear, .black.opacity(0.65)],
                startPoint: .center,
                endPoint: .bottom
            )
            .matchedGeometryEffect(id: "pasta-gradient-\(pasta.id)", in: namespace, isSource: isSource)

            VStack(alignment: .leading, spacing: 2) {
                Text(pasta.category)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.9))
                    .clipShape(Capsule())
                    .matchedGeometryEffect(id: "pasta-category-\(pasta.id)", in: namespace, isSource: isSource)

                Text(pasta.title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .matchedGeometryEffect(id: "pasta-title-\(pasta.id)", in: namespace, isSource: isSource)
            }
            .padding(8)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
    }
}

// MARK: - PastaGridDetailOverlay

struct PastaGridDetailOverlay: View {

    let pasta: PastaEntity
    let namespace: Namespace.ID
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    Image(pasta.imageName, bundle: .module)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 320)
                        .clipped()
                        .matchedGeometryEffect(id: "pasta-image-\(pasta.id)", in: namespace)

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.75)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 320)
                    .matchedGeometryEffect(id: "pasta-gradient-\(pasta.id)", in: namespace)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(pasta.category)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.9))
                            .clipShape(Capsule())
                            .matchedGeometryEffect(id: "pasta-category-\(pasta.id)", in: namespace)

                        Text(pasta.title)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .matchedGeometryEffect(id: "pasta-title-\(pasta.id)", in: namespace)
                    }
                    .padding(20)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text(pasta.catchCopy)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(pasta.descriptionText)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
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
            .padding(.top, 60)
            .padding(.leading, 20)
        }
    }
}

// MARK: - Preview

#Preview("Grid Screen") {
    PastaGridScreenView()
}

#Preview("Grid Card") {
    @Previewable @Namespace var ns
    return PastaGridCard(
        pasta: PastaEntity(
            pastaID: 1,
            title: "カルボナーラ",
            category: "クリーム",
            catchCopy: "濃厚卵黄",
            descriptionText: "説明",
            imageName: "Pasta/pasta_01"
        ),
        namespace: ns,
        isSource: true
    )
    .frame(width: 130, height: 130)
    .padding()
}
