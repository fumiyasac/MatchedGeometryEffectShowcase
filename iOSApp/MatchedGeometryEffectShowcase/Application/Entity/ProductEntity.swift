//
//  ProductEntity.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/06/23.
//

import Foundation

struct ProductEntity {

    // MARK: - Property

    let identifier: UUID = UUID()
    let productID: Int
    let isPremium: Bool
    let isSale: Bool
    let percentSale: Int
    let regularPrice: Int
    let productName: String
    let productSummary: String
    let productDescription: String
    let mainCategory: String
    let subCategory: String
    let hashtags: [String]
    let productPhotoUrl: URL?
}
