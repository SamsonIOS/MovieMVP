// MockRouter.swift
// Copyright © RoadMap. All rights reserved.

@testable import MovieMVP
import UIKit

/// Мок Роутера
final class MockRouter: Routerable {
    // MARK: - Public Properties

    var builder: Builderable?

    var navigationController: UINavigationController? = UINavigationController()

    var builderable: Builderable?

    // MARK: - Init

    init(builderable: Builderable) {
        self.builderable = builderable
    }

    // MARK: - Public Methods

    func moviesViewController() {}

    func showDetailMoviesViewController(id: Int) {}
}
