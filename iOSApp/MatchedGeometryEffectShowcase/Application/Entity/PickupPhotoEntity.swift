//
//  PickupPhotoEntity.swift
//  MatchedGeometryEffectShowcase
//
//  Created by 酒井文也 on 2024/11/15.
//

import Foundation

struct PickupPhotoEntity {

    // MARK: - Property

    let identifier: UUID = UUID()
    let pickupPhotoID: Int
    let title: String
    let pickupPhotoUrl: URL?
}
