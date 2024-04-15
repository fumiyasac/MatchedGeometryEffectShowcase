//
//  GalleryScreenViewController.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/04/15.
//

import UIKit

final class GalleryScreenViewController: UIViewController {

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        // MEMO: UIKitのNavigationController表示を実施する
        setupNavigationBarTitle("Gallery")
        removeBackButtonText()
    }
}
