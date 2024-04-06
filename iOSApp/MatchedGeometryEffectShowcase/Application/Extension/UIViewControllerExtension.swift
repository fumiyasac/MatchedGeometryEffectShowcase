//
//  UIViewControllerExtension.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/04/06.
//

import Foundation
import UIKit

// UIViewControllerの拡張
extension UIViewController {

    // この画面のナビゲーションバーを設定するメソッド
    public func setupNavigationBarTitle(_ title: String) {

        // NavigationControllerのデザイン調整を行う
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.white

        // NavigationBarをタイトル配色を決定する
        guard let nav = self.navigationController else {
            return
        }
        nav.navigationBar.barTintColor = UIColor(code: "#869a42")
        nav.navigationBar.titleTextAttributes = attributes

        // タイトルを入れる
        self.navigationItem.title = title
    }

    // 戻るボタンの「戻る」テキストを削除した状態にするメソッド
    public func removeBackButtonText() {

        // NavigationBarをタイトル配色を決定する
        guard let nav = self.navigationController else {
            return
        }
        nav.navigationBar.tintColor = UIColor.white

        self.navigationItem.backButtonDisplayMode = .minimal
        self.navigationItem.backButtonTitle = self.navigationItem.title
    }
}
