// DetailMoviesable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол детального описания фильма
protocol DetailMoviesable {
    var detailMovies: Movies? { get set }
    var actors: [Actor] { get set }

    func fetchDetailMovies()
    func fetchActor()
}