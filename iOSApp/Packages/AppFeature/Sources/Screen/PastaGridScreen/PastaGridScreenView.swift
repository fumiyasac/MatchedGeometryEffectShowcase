import SwiftUI
import Entity
import AppExtension
import Common
import Infrastructure
import ViewStateProvider

// MARK: - SwiftUI製 3列1pxグリッド + matchedGeometryEffect による詳細遷移
// CharacteristicStyleSwiftUIExample の Gallery 画面構造を参考に:
//   - selectedPasta / selectedImage を本体 struct で @State 管理
//   - 詳細表示は別 struct (PastaSelectedImageView) に切り出し、@Binding で連携
//   - Grid 側は選択中に opacity=0 で操作不可にし、.overlay で詳細を重ねる
//   - ImageインスタンスをStateに持たせて連続的なAnimationを実現する
//   - 拡大→Dismiss のドラッグ中は dragPosition を親と共有し、進捗に応じて
//     下のグリッドの opacity を 0 → 1 に段階的に戻すことで透過プレビューを実現する

public struct PastaGridScreenView: View {

    // MARK: - ViewStateProvider

    // @MainActor isolated な PastaStateProvider を struct init から直接初期化すると
    // Swift 6 の strict concurrency でエラーになるため @State ラップで遅延生成する
    @State private var stateProvider = PastaStateProvider()

    // MARK: - Property (Grid Layout)

    // 3列・隙間 1pt
    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 1.0), count: 3)

    // MARK: - Property (Display Animation)

    // 選択された画面切り替え対象のEntityを格納する
    @State private var selectedPasta: PastaEntity?

    // 選択された画面切り替え対象のImage要素を格納する
    // 👉 Image自体を渡して連続的なAnimationにする
    @State private var selectedImage: Image?

    // 拡大表示中のドラッグ変化量を親子で共有する
    // 👉 PastaSelectedImageView が更新し、こちら側はグリッドの opacity 算出に利用する
    @State private var dragPosition: CGSize = .zero

    // .matchedGeometryEffectで利用する名前空間
    @Namespace private var namespace

    // MARK: - Constants

    // ドラッグによる dismiss 閾値（この距離を超えると閉じる、同時にグリッドが完全に見える状態になる）
    private static let dismissThreshold: CGFloat = 200.0

    // MARK: - Computed

    // ドラッグ進捗 (0.0 〜 1.0)
    private var dragProgress: CGFloat {
        min(abs(dragPosition.height) / Self.dismissThreshold, 1.0)
    }

    // グリッドの opacity:
    //   - 未選択時: 1
    //   - 選択中かつドラッグなし: 0（完全に隠す）
    //   - 選択中かつドラッグ中: dragProgress に比例して 0 → 1 に増加
    private var gridOpacity: CGFloat {
        guard selectedImage != nil else { return 1.0 }
        return dragProgress
    }

    // MARK: - Initializer

    public init() {}

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            Group {
                switch stateProvider.requestState {
                case .success:
                    threeColumnGridScrollView()
                case .error:
                    ConnectionErrorView {
                        Task { await stateProvider.fetchAll() }
                    }
                case .requesting, .none:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Pasta Grid")
            .navigationBarTitleDisplayMode(.large)
        }
        .task { await stateProvider.fetchAll() }
    }

    // MARK: - Private

    @ViewBuilder
    private func threeColumnGridScrollView() -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 1.0) {
                    ForEach(stateProvider.pastaList, id: \.id) { pasta in
                        // ローカルBundle画像を取得する
                        let image = Image(pasta.imageName, bundle: .module)

                        // 角丸なし・scaledToFit で正方画像をそのまま敷き詰める
                        image
                            .resizable()
                            .scaledToFit()
                            // 拡大表示先のViewに配置した要素Imageと同様に一意なID文字列と名前空間を定める
                            .matchedGeometryEffect(id: "pasta-\(pasta.id)", in: namespace, isSource: selectedImage == nil)
                            .onTapGesture {
                                // 選択された画面切り替え対象のEntityとImage要素を変数に格納してAnimationを実行する
                                withAnimation(.spring(response: 0.36, dampingFraction: 0.48)) {
                                    selectedImage = image
                                    selectedPasta = pasta
                                }
                            }
                    }
                }
            }
            // 拡大画像表示が選択されている時はGrid表示のアルファ値を 0 に落とし、
            // ドラッグ中は進捗に応じて徐々に透過を解除して下のグリッドを見える様にする
            .opacity(gridOpacity)
            .allowsHitTesting(selectedImage == nil)
        }
        .overlay {
            // .overlayを利用して拡大画像表示を上に重ねる
            if selectedPasta != nil {
                PastaSelectedImageView(
                    selectedPasta: $selectedPasta,
                    selectedImage: $selectedImage,
                    dragPosition: $dragPosition,
                    dismissThreshold: Self.dismissThreshold,
                    namespace: namespace
                )
            }
        }
    }
}

// MARK: - PastaSelectedImageView

struct PastaSelectedImageView: View {

    // MARK: - Property (Display Animation)

    // 選択された画面切り替え対象のEntityと連動する
    @Binding var selectedPasta: PastaEntity?

    // 選択された画面切り替え対象のImage要素と連動する
    @Binding var selectedImage: Image?

    // DragGestureでの変化量を親と共有する（親のグリッド opacity 算出に利用される）
    @Binding var dragPosition: CGSize

    // Dismiss 判定閾値（親から受け取る）
    let dismissThreshold: CGFloat

    // .matchedGeometryEffectで利用する名前空間
    let namespace: Namespace.ID

    // MARK: - Body

    var body: some View {
        VStack {
            if let pasta = selectedPasta, let cachedSelectedImage = selectedImage {

                // 拡大画像が存在する場合は比率を維持した状態で横幅いっぱいに表示する
                cachedSelectedImage
                    .resizable()
                    .scaledToFit()
                    .matchedGeometryEffect(id: "pasta-\(pasta.id)", in: namespace, isSource: selectedImage != nil)
                    .onTapGesture {
                        dismiss()
                    }
                    // DragGestureでの変化量と要素が追従する様にoffset値を更新する
                    .offset(dragPosition)
                    // DragGestureを実行し、①移動中は変化量を変数に格納する、②終了時は高さの閾値を見て超過する場合は表示を元に戻す、の2つを実行する
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragPosition = value.translation
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.36, dampingFraction: 0.48)) {
                                    if dismissThreshold < abs(dragPosition.height) {
                                        // Dismiss：先に dragPosition をリセットしてから close
                                        selectedImage = nil
                                        selectedPasta = nil
                                        dragPosition = .zero
                                    } else {
                                        // 閾値未満なら元の位置に戻る → グリッドは opacity 0 に戻る
                                        dragPosition = .zero
                                    }
                                }
                            }
                    )
            } else {

                // 拡大画像が存在しない場合は白色背景を表示する
                Color(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Private

    private func dismiss() {
        withAnimation(.spring(response: 0.36, dampingFraction: 0.48)) {
            selectedImage = nil
            selectedPasta = nil
            dragPosition = .zero
        }
    }
}

// MARK: - Preview

#Preview("Grid Screen") {
    PastaGridScreenView()
}
