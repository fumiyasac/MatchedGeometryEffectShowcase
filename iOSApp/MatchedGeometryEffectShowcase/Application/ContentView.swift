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

// MEMO: 簡単なMatchedGeometryEffectを利用した表現を利用したサンプルを作成する
// → UIKitでカスタムトランジションの様な感じを表現する

struct ContentView: View {

    // MARK: - Body

    var body: some View {
        ZStack {
            TabView {
                // Feedコンテンツ画面
                // ※ SwiftUI製画面
                FeedScreenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Feed")
                        }
                    }
                    .tag(0)
                // Galleryコンテンツ画面
                // ※ UIKit製画面
                GalleryScreenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "tray.full.fill")
                            Text("Gallery")
                        }
                    }.tag(1)
            }
            .accentColor(Color(uiColor: UIColor(code: "#ffd900")))
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
