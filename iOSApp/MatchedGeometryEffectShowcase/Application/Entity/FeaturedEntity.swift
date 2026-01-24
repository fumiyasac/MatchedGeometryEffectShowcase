//
//  FeaturedEntity.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2026/01/24.
//

import Foundation

struct FeaturedEntity {

    // MARK: - Property

    let identifier: UUID = UUID()
    let featuredID: Int
    let category: String
    let title: String
    let catchCopy: String
    let descriptionText: String
    let rating: Float
    let thumbnailUrl: URL?
}
