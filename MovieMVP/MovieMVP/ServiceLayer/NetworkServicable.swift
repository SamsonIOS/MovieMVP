// NetworkServicable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Работа с сетью
protocol NetworkServicable {
    func fetchActorData(actorsID: Int, completion: @escaping (Result<[Actor], Error>) -> ())
    func fetchDetailMovies(id: Int, completion: @escaping (Result<Movies, Error>) -> ())
    func fetchMovies(requestType: RequestType, completion: @escaping (Result<[Movies], Error>) -> Void)
}
