// Router.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Роутер
final class Router: Routerable {
    // MARK: - Public Properties

    var navigationController: UINavigationController?
    var builder: Builderable?

    // MARK: - Initializers

    init(navigationController: UINavigationController, builder: Builderable) {
        self.navigationController = navigationController
        self.builder = builder
    }

    // MARK: - Public methods

    func moviesViewController() {
        if let navigationController = navigationController {
            guard let movieCatalogViewController = builder?.makeMoviesViewController(router: self) else { return }
            navigationController.viewControllers = [movieCatalogViewController]
        }
    }

    func showDetailMoviesViewController(id: Int) {
        if let navigationController = navigationController {
            guard let movieDetailViewController = builder?.makeDetailMoviesViewController(id: id, router: self)
            else { return }
            navigationController.pushViewController(movieDetailViewController, animated: true)
        }
    }
}
