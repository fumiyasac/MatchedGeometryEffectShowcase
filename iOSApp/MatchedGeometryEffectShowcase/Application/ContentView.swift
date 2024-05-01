//
//  ContentView.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/02/13.
//

import SwiftUI
import UIKit

// MEMO: 簡単なMatchedGeometryEffectを利用した表現を利用したサンプルを作成する
// → UIKitでカスタムトランジションの様な感じを表現する

struct ContentView: View {

    // MARK: - Body

    var body: some View {
        ZStack {
            TabView {
                // Feedコンテンツ画面
                FeedScreenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Feed")
                        }
                    }
                    .tag(0)
                // Pickupコンテンツ画面
                PickupScreenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book.pages.fill")
                            Text("Pickup")
                        }
                    }
                    .tag(1)
                // Popularコンテンツ画面
                PopularScreenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "photo.stack.fill")
                            Text("Popular")
                        }
                    }.tag(2)
                // Galleryコンテンツ画面
                GalleryScreenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "tray.full.fill")
                            Text("Gallery")
                        }
                    }.tag(3)
            }
            .accentColor(Color(uiColor: UIColor(code: "#869a42")))
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
