//
//  GalleryDetailHeaderView.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/04/17.
//

import Foundation
import UIKit

final class GalleryDetailHeaderView: CustomViewBase {

    // MARK: - Property

    var headerBackButtonTappedHandler: (() -> ())?

    @IBOutlet weak private var headerBackButton: UIButton!
    @IBOutlet weak private var headerTitleLabel: UILabel!

    // MARK: - Initializer

    required init(frame: CGRect) {
        super.init(frame: frame)

        setupGalleryDetailHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupGalleryDetailHeaderView()
    }

    // MARK: - Function

    func setTitle(_ title: String) {
        headerTitleLabel.text = title
    }

    func changeAlpha(_ targetAlpha: CGFloat) {
        if targetAlpha > 1 {
            headerTitleLabel.alpha = 1
        } else if 0...1 ~= targetAlpha {
            headerTitleLabel.alpha = targetAlpha
        } else {
            headerTitleLabel.alpha = 0
        }
    }

    // MARK: - Private Function

    private func setupGalleryDetailHeaderView() {
        headerBackButton.addTarget(self, action:  #selector(self.headerBackButtonTapped(sender:)), for: .touchUpInside)
    }

    // ViewController側でクロージャー内にセットした処理を実行する
    @objc private func headerBackButtonTapped(sender: UIButton) {
        headerBackButtonTappedHandler?()
    }
}
