//
//  ContentView.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/02/13.
//

import SwiftUI

// MEMO: 簡単なMatchedGeometryEffectを利用した表現を利用したサンプルを作成する

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
