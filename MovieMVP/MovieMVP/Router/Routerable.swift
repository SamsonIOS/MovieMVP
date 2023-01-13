// Routerable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол роутера
protocol Routerable: RouterMainProtocol {
    func moviesViewController()
    func showDetailMoviesViewController(id: Int)
}
