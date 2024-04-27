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

// MARK: - StoryboardInstantiatable

extension GalleryScreenViewController: StoryboardInstantiatable {

    // このViewControllerに対応するStoryboard名
    static var storyboardName: String {
        return "GalleryScreenViewController"
    }

    // このViewControllerに対応するViewControllerのIdentifier名
    static var viewControllerIdentifier: String? {
        return nil
    }
}
