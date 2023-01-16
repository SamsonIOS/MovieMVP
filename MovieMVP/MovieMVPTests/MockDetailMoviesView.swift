// MockDetailMoviesView.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
@testable import MovieMVP

/// Моковый контроллер с детальным описанием фильма
final class MockDetailMoviesView: DetailMoviesViewable {
    // MARK: - Public Methods

    func succes() {}

    func failure(_ error: Error) {}

    func setupUI(movieDetail: MovieMVP.Movies?, imageURL: String, imageService: ImageServicable) {}
}
