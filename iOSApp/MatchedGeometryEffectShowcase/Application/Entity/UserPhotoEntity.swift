//
//  UserPhotoEntity.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/06/23.
//

import Foundation

struct UserPhotoEntity {

    // MARK: - Property

    let identifier: UUID = UUID()
    let userPhotoID: Int
    let category: String
    let title: String
    let catchCopy: String
    let descriptionText: String
    let userPhotoUrl: URL?
}
