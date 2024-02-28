import SwiftUI

final class ContentRouter {}

// MARK: - RouteToContentContract

protocol RouteToContentContract {
    func routeToPickup() -> PickupScreenView
    func routeToPopular() -> PopularScreenView
}

// MARK: - ContentRouter

extension ContentRouter: RouteToContentContract {

    func routeToPickup() -> PickupScreenView {
        PickupScreenView()
    }

    func routeToPopular() -> PopularScreenView {
        PopularScreenView()
    }
}
