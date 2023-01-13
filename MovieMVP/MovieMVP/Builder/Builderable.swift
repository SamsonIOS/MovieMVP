// Builderable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол билдера
protocol Builderable {
    func makeMoviesViewController(router: Routerable) -> MoviesViewController
    func makeDetailMoviesViewController(id: Int, router: Routerable) -> DetailMoviesViewController
}
