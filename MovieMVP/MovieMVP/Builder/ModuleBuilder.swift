// ModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Билдер
final class Builder: Builderable {
    // MARK: - Public methods

    func makeMoviesViewController(router: Routerable) -> MoviesViewController {
        let keychainService = KeychainService()
        let viewController = MoviesViewController()
        let realmService = RealmService()
        let imageService = ImageService()
        let networkService = NetworkService(keychainService: keychainService)
        let presenter = MoviesPresenter(
            view: viewController,
            networkService: networkService,
            router: router,
            realmService: realmService,
            imageService: imageService
        )
        viewController.presenter = presenter
        return viewController
    }

    func makeDetailMoviesViewController(id: Int, router: Routerable) -> DetailMoviesViewController {
        let viewController = DetailMoviesViewController()
        let keychainService = KeychainService()
        let realmService = RealmService()
        let imageService = ImageService()
        let networkService = NetworkService(keychainService: keychainService)
        let presenter = DetailMoviesPresenter(
            view: viewController,
            networkService: networkService,
            id: id,
            router: router,
            realmService: realmService,
            imageService: imageService
        )
        viewController.presenter = presenter
        return viewController
    }
}
