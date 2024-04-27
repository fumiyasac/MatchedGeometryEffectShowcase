//
//  FeedScreenView.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/04/27.
//

import SwiftUI

// MEMO: SwiftUIを利用した「MatchedGeometryEffect」を利用した表現
struct FeedScreenView: View {
    var body: some View {
        // MEMO: UIKitのNavigationController表示を実施する
        NavigationStack {
            Group {
                VStack {
                    Text("Feed")
                }
            }
            // Navigation表示に関する設定
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FeedScreenView()
}
