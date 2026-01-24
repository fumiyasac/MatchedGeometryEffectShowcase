import SwiftUI
import AppExtension

public struct ConnectionErrorView: View {

    // MARK: - Typealias

    public typealias TapButtonAction = () -> Void

    // MARK: - Property

    private var connectionErrorTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 18)
    }

    private var connectionErrorTitleColor: Color {
        return Color.primary
    }

    private var connectionErrorButtonFont: Font {
        return Font.custom("AvenirNext-Bold", size: 16)
    }

    private var connectionErrorButtonColor: Color {
        return Color.orange
    }

    private var tapButtonAction: ConnectionErrorView.TapButtonAction

    // MARK: - Initializer

    public init(tapButtonAction: @escaping ConnectionErrorView.TapButtonAction) {
        self.tapButtonAction = tapButtonAction
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0.0) {
            Spacer()
            VStack {
                Text("Error: 表示データ取得失敗")
                    .font(connectionErrorTitleFont)
                    .foregroundColor(connectionErrorTitleColor)
                HStack {
                    Spacer()
                    Button(action: tapButtonAction, label: {
                        Text("再読み込みを実行する")
                            .font(connectionErrorButtonFont)
                            .foregroundColor(connectionErrorButtonColor)
                            .background(.white)
                            .frame(width: 240.0, height: 48.0)
                            .cornerRadius(24.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24.0)
                                    .stroke(connectionErrorButtonColor, lineWidth: 1.0)
                            )
                    })
                    Spacer()
                }
                .padding(.vertical, 24.0)
            }
            Spacer()
        }
        .padding(.horizontal, 12.0)
    }
}

// MARK: - Preview

#Preview {
    ConnectionErrorView(tapButtonAction: {})
}
