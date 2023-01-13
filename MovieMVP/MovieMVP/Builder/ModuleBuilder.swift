// ModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Билдер
final class Builder: Builderable {
    // MARK: - Public methods

    func makeMoviesViewController(router: Routerable) -> MoviesViewController {
        let viewController = MoviesViewController()
        let networkService = NetworkService()
        let presenter = MovieCatalogPresenter(view: viewController, networkService: networkService, router: router)
        viewController.presenter = presenter
        return viewController
    }

    func makeDetailMoviesViewController(id: Int, router: Routerable) -> DetailMoviesViewController {
        let viewController = DetailMoviesViewController()
        let networkService = NetworkService()
        let presenter = DetailMoviesPresenter(
            view: viewController,
            networkService: networkService,
            id: id,
            router: router
        )
        viewController.presenter = presenter
        return viewController
    }
}
