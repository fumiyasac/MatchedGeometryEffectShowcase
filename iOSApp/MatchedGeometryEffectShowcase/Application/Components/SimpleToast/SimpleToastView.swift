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

import SwiftUI

// MARK: - Struct

public struct SimpleToast: Equatable {

    // MARK: - Property

    var style: SimpleToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}
