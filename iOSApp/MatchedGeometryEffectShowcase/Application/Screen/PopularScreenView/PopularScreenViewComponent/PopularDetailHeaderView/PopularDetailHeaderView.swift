//
//  PopularDetailHeaderView.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/04/13.
//

import UIKit

final class PopularDetailHeaderView: CustomViewBase {

    // MARK: - Property

    var headerBackButtonTappedHandler: (() -> ())?
    
    @IBOutlet weak private var headerBackgroundView: UIView!
    @IBOutlet weak private var headerWrappedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var headerTitle: UILabel!
    @IBOutlet weak private var headerBackButton: UIButton!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupPopularDetailHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupPopularDetailHeaderView()
    }

    // MARK: - Function

    // ダミーのヘッダー内にあるタイトルをセットする
    func setTitle(_ title: String?) {
        headerTitle.text = title
    }

    // ダミーのヘッダー内にある背景Viewのアルファ値をセットする
    func setHeaderBackgroundViewAlpha(_ alpha: CGFloat) {
        headerBackgroundView.alpha = alpha
    }

    // ダミーのヘッダー内の上方向の制約を更新する
    // 引数「constraint」の算出方法について: (画像のパララックス効果付きのViewの高さ) - (NavigationBarの高さを引いたもの) - (UIScrollView側のY軸方向のスクロール量)
    func setHeaderNavigationTopConstraint(_ constant: CGFloat) {
        // 初期状態のheaderWrappedViewTopConstraintのマージン値(StatusBarの高さと同値)
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        let defaultHeaderMargin = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if constant > 0 {
            headerWrappedViewTopConstraint.constant = defaultHeaderMargin + constant
        } else {
            headerWrappedViewTopConstraint.constant = defaultHeaderMargin
        }
        self.layoutIfNeeded()
    }

    // MARK: - Private Function

    private func setupPopularDetailHeaderView() {
        headerBackButton.addTarget(self, action:  #selector(self.headerBackButtonTapped(sender:)), for: .touchUpInside)
    }

    // ViewController側でクロージャー内にセットした処理を実行する
    @objc private func headerBackButtonTapped(sender: UIButton) {
        headerBackButtonTappedHandler?()
    }
}
