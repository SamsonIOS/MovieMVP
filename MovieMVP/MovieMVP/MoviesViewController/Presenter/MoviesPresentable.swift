// MoviesPresentable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол презентера фильмов
protocol MoviesPresentable {
    var movies: [Movies] { get set }
    var imageService: ImageServicable { get }
    func cellForRowAt(indexPath: IndexPath) -> Movies
    func fetchMovies(requestType: RequestType)
    func selectMovie(id: Int)
    func switchMovies(tag: Int)
}
