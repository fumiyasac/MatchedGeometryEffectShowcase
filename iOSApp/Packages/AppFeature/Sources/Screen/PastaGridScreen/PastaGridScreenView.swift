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

    // .matchedGeometryEffectで利用する名前空間
    @Namespace private var namespace

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
            // 拡大画像表示が選択されている時はGrid表示のアルファ値を0にして操作ができない様にする
            .opacity(selectedImage == nil ? 1 : 0)
        }
        .overlay {
            // .overlayを利用して拡大画像表示を上に重ねる
            if selectedPasta != nil {
                PastaSelectedImageView(
                    selectedPasta: $selectedPasta,
                    selectedImage: $selectedImage,
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

    // .matchedGeometryEffectで利用する名前空間
    let namespace: Namespace.ID

    // MARK: - Property (DragGesture Translation)

    // DragGestureでの変化量を格納する
    @State private var position = CGSize.zero

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
                        withAnimation(.spring(response: 0.36, dampingFraction: 0.48)) {
                            selectedImage = nil
                            selectedPasta = nil
                        }
                    }
                    // DragGestureでの変化量と要素が追従する様にoffset値を更新する
                    .offset(position)
                    // DragGestureを実行し、①移動中は変化量を変数に格納する、②終了時は高さの閾値を見て超過する場合は表示を元に戻す、の2つを実行する
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                position = value.translation
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.36, dampingFraction: 0.48)) {
                                    if 200.0 < abs(position.height) {
                                        selectedImage = nil
                                        selectedPasta = nil
                                    } else {
                                        position = .zero
                                    }
                                }
                            }
                    )
            } else {

                // 拡大画像が存在しない場合は白色背景を表示する
                Color(.white)
            }
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("Grid Screen") {
    PastaGridScreenView()
}
