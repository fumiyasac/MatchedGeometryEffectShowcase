//
//  PopularScreenViewController.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/04/06.
//

import UIKit

final class PopularScreenViewController: UIViewController {

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        // MEMO: UIKitのNavigationController表示を実施する
        setupNavigationBarTitle("Popular")
        removeBackButtonText()
    }
}
