//
//  PopularArticleEntity.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/11/25.
//

import Foundation

struct PopularArticleEntity {

    // MARK: - Property

    let identifier: UUID = UUID()
    let articleID: Int
    let articleTitle: String
    let articleText: String
    let articleMainCategory: String
    let articleSubCategory: String
    let articleHashtags: [String]
    let articlePhotoUrl: URL?
}
