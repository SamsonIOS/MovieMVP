// MockModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
@testable import MovieMVP

/// Мок билдера
final class MockModuleBuilder: Builderable {
    // MARK: - Public Methods

    func makeMoviesViewController(router: Routerable) -> MoviesViewController {
        MoviesViewController()
    }

    func makeDetailMoviesViewController(id: Int, router: Routerable) -> DetailMoviesViewController {
        DetailMoviesViewController()
    }
}
