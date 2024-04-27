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

// MARK: - StoryboardInstantiatable

extension PopularScreenViewController: StoryboardInstantiatable {

    // このViewControllerに対応するStoryboard名
    static var storyboardName: String {
        return "PopularScreenViewController"
    }

    // このViewControllerに対応するViewControllerのIdentifier名
    static var viewControllerIdentifier: String? {
        return nil
    }
}
