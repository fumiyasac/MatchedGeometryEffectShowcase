import SwiftUI

// MARK: - Struct

public struct SimpleToast: Equatable {

    // MARK: - Property

    var style: SimpleToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}

// MARK: - SimpleToastView

// MEMO: 下記記事を参考にして作成していきます
//
/*
content
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay(
        ZStack {
            simpleToastView()
                .offset(y: 64.0)
        }
        .animation(.spring(), value: toast)
    )
*/

public struct SimpleToastView: View {

    // MARK: - Property

    var style: SimpleToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)

    // MARK: - Body

    public var body: some View {
        //
        HStack(alignment: .center, spacing: 12.0) {
            //
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
            //
            Text(message)
                .font(Font.caption)
                .foregroundColor(Color("toastForeground"))
            //
            Spacer(minLength: 10.0)
            //
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0.0, maxWidth: width)
        .background(Color("toastBackground"))
        .cornerRadius(8.0)
        .overlay(
            //
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(style.themeColor, lineWidth: 1.0)
                .opacity(0.6)
        )
        .padding(.horizontal, 16.0)
    }
}
