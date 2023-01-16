// MockNetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
@testable import MovieMVP
import SwiftyJSON

/// Мок сервиса по запросу данных с API
final class MockNetworkService: NetworkServicable {
    // MARK: - Constants

    private enum Constants {
        static let mockActors = "MockActors"
        static let castText = "cast"
        static let emptyString = ""
        static let mockMovieText = "MockMovie"
        static let resultsText = "results"
        static let mockDetailMovieText = "MockMovieInfo"
        static let jsonText = "json"
        static let errorText = "error"
        static let codeNumber = 0
    }

    // MARK: - Private Properties

    private var movie: [Movies]?
    private var movieInfo: Movies?
    private var actor: [Actor]?
    private var json = JSON()

    // MARK: - Init

    init() {}

    convenience init(movie: [Movies]?) {
        self.init()
        self.movie = movie
    }

    convenience init(movieInfo: Movies?) {
        self.init()
        self.movieInfo = movieInfo
    }

    convenience init(actor: [Actor]?) {
        self.init()
        self.actor = actor
    }

    // MARK: - Public Methods

    func fetchActorData(actorsID: Int, completion: @escaping (Result<[Actor], Error>) -> ()) {
        if var actor = actor {
            let json = getData(name: Constants.mockActors)
            let actorJSON = json[Constants.castText].arrayValue.map { Actor(json: $0) }
            actor = actorJSON
            completion(.success(actor))
        } else {
            let error = NSError(domain: Constants.emptyString, code: Constants.codeNumber)
            completion(.failure(error))
        }
    }

    func fetchMovies(requestType: RequestType, completion: @escaping (Result<[Movies], Error>) -> Void) {
        if var movie = movie {
            let json = getData(name: Constants.mockMovieText)
            let movieJSON = json[Constants.resultsText].arrayValue.map { Movies(json: $0) }
            movie = movieJSON
            completion(.success(movie))
        } else {
            let error = NSError(domain: Constants.emptyString, code: Constants.codeNumber)
            completion(.failure(error))
        }
    }

    func fetchDetailMovies(id: Int, completion: @escaping (Result<Movies, Error>) -> ()) {
        if var movieInfo = movieInfo {
            let json = getData(name: Constants.mockDetailMovieText)
            let movieInfoJSON = Movies(json: json)
            movieInfo = movieInfoJSON
            completion(.success(movieInfo))
        } else {
            let error = NSError(domain: Constants.emptyString, code: Constants.codeNumber)
            completion(.failure(error))
        }
    }

    // MARK: - Private Methods

    private func getData(name: String, withExtension: String = Constants.jsonText) -> JSON {
        guard let jsonURL = Bundle.main.path(forResource: name, ofType: withExtension)
        else { return JSON() }
        do {
            let fileURL = URL(fileURLWithPath: jsonURL)
            let data = try Data(contentsOf: fileURL)
            let json = try JSON(data: data)
            return json
        } catch {
            print(Constants.errorText)
        }
        return JSON()
    }
}
