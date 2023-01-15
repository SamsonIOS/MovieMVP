// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import SwiftyJSON

/// Сетевой сервис
final class NetworkService: NetworkCoreService, NetworkServicable {
    // MARK: - Constants

    private enum Constants {
        static let detailsUrlString = "?api_key=\(NetworkAPI.token)&language=ru-RU"
        static let actorUrlString = "/credits?api_key=\(NetworkAPI.token)"
    }

    // MARK: Public Methods

    func fetchActorData(actorsID: Int, completion: @escaping (Result<[Actor], Error>) -> ()) {
        downloadJson(urlString: "\(NetworkAPI.infoURL)\(actorsID)\(Constants.actorUrlString)") { result in
            switch result {
            case let .success(json):
                let actors = json["cast"].arrayValue.map { Actor(json: $0) }
                completion(.success(actors))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchDetailMovies(id: Int, completion: @escaping (Result<Movies, Error>) -> ()) {
        downloadJson(urlString: "\(NetworkAPI.infoURL)\(id)\(Constants.detailsUrlString)") { result in
            switch result {
            case let .success(json):
                completion(.success(Movies(json: json)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchMovies(requestType: RequestType, completion: @escaping (Result<[Movies], Error>) -> Void) {
        downloadJsonResult(requestType: requestType) { result in
            switch result {
            case let .success(json):
                let movies = json["results"].arrayValue.map { Movies(json: $0) }
                completion(.success(movies))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
