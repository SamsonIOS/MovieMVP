// MockMoviesView.swift
// Copyright © RoadMap. All rights reserved.

//
//  MockMoviesView.swift
//  MovieMVPTests
//
//  Created by coder on 15.01.2023.
//
import Foundation
@testable import MovieMVP

/// Мок презентера экрана с фильмами
final class MockMovieView: MoviesViewProtocol {
    // MARK: - Public Methods

    func succes() {}

    func failure(_ error: Error) {}
}
