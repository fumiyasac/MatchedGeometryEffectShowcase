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

    // MARK: - Propety

    private let contentRouter = ContentRouter()

    // MARK: - Body

    var body: some View {
        ZStack {
            TabView {
                contentRouter.routeToPickup()
                    .tabItem {
                        VStack {
                            Image(systemName: "tray.full.fill")
                            Text("Pickup")
                        }
                    }
                    .tag(0)
                contentRouter.routeToPopular()
                    .tabItem {
                        VStack {
                            Image(systemName: "photo.stack.fill")
                            Text("Popular")
                        }
                    }.tag(1)
            }
            .accentColor(Color(uiColor: UIColor(code: "#869a42")))
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
