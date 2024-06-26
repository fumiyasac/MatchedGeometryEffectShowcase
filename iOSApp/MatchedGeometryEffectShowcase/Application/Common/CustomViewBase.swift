//
//  CustomViewBase.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/04/14.
//

import UIKit

// 自作のXibを使用するための基底となるUIViewを継承したクラス
// 参考：http://skygrid.co.jp/jojakudoctor/swift-custom-class/

class CustomViewBase: UIView {

    // コンテンツ表示用のView
    weak var contentView: UIView!

    // このカスタムViewをコードで使用する際の初期化処理
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
    }

    // このカスタムViewをInterfaceBuilderで使用する際の初期化処理
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContentView()
    }

    // コンテンツ表示用Viewの初期化処理
    private func initContentView() {

        // 追加するcontentViewのクラス名を取得する
        let viewClass: AnyClass = type(of: self)

        // 追加するcontentViewに関する設定をする
        contentView = Bundle(for: viewClass)
            .loadNibNamed(String(describing: viewClass), owner: self, options: nil)?.first as? UIView
        contentView.autoresizingMask = autoresizingMask
        contentView.frame = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        // 追加するcontentViewの制約を設定する ※上下左右へ0の制約を追加する
        let bindings = ["view": contentView as Any]

        let contentViewConstraintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        let contentViewConstraintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        addConstraints(contentViewConstraintH)
        addConstraints(contentViewConstraintV)
    }
}
