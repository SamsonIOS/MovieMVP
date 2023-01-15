// NetworkCoreService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation
import SwiftyJSON

/// Сетевые запросы
class NetworkCoreService {
    // MARK: Constants

    private enum Constants {
        static let apiKeyText = "api_key"
        static let languageText = "language"
        static let languageOfInfoAboutMovies = "ru-RU"
        static let pageText = "page"
        static let httpsText = "https"
        static let hostText = "api.themoviedb.org"
    }

    // MARK: - Private properties

    private var keychainService: KeychainServicable

    // MARK: - Initializers

    init(keychainService: KeychainServicable) {
        self.keychainService = keychainService
    }

    // MARK: - Public methods

    func downloadJson(urlString: String, completion: @escaping (Result<JSON, Error>) -> Void) {
        AF.request(urlString, method: .get).validate().responseJSON { response in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                completion(.success(json))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func downloadJsonResult(
        requestType: RequestType,
        completion: @escaping (Result<JSON, Error>) -> Void
    ) {
        var queryItems =
            [URLQueryItem(name: Constants.apiKeyText, value: keychainService.getAPI(key: NetworkAPI.keychainKey))]
        queryItems.append(URLQueryItem(name: Constants.languageText, value: Constants.languageOfInfoAboutMovies))

        var components = URLComponents()
        components.scheme = Constants.httpsText
        components.host = Constants.hostText
        components.path = requestType.rawValue
        components.queryItems = queryItems

        guard let url = components.url else { return }

        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                completion(.success(json))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchImageData(_ url: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url).response { response in
            guard let data = response.data else { return }
            completion(.success(data))
        }
    }
}
