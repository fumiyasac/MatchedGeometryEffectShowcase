//
//  ContentView.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/02/13.
//

import SwiftUI
import UIKit
import Screen
import AppExtension

// MEMO: UIKit と SwiftUI の画面遷移を比較するためのタブ構成
// Tab1: UIKit Pasta Gallery (UICollectionViewCompositionalLayout + カスタムトランジション)
// Tab2: SwiftUI Pasta Grid (3列グリッド + matchedGeometryEffect)
// Tab3: SwiftUI Tapas Timeline (.matchedTransitionSource + .navigationTransition(.zoom))

struct ContentView: View {

    // MARK: - Body

    var body: some View {
        TabView {

            // UIKit製: パスタギャラリー
            PastaGalleryScreenView()
                .tabItem {
                    Label("Gallery", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)

            // SwiftUI製: パスタ 3列グリッド
            PastaGridScreenView()
                .tabItem {
                    Label("Grid", systemImage: "square.grid.3x3.fill")
                }
                .tag(1)

            // SwiftUI製: タパス タイムライン
            TapasTimelineScreenView()
                .tabItem {
                    Label("Tapas", systemImage: "list.bullet.rectangle.portrait.fill")
                }
                .tag(2)
        }
        .accentColor(Color(uiColor: UIColor(code: "#FCD7A1")))
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
