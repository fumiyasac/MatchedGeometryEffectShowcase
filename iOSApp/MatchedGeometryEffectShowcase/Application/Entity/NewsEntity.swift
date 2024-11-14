//
//  NewsEntity.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/11/15.
//

import Foundation

struct NewsEntity {

    // MARK: - Property

    let identifier: UUID = UUID()
    let newsID: Int
    let category: String
    let title: String
    let descriptionText: String
    let thumbnailUrl: URL?
}
