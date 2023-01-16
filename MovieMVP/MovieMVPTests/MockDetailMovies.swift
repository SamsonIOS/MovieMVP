// MockDetailMovies.swift
// Copyright © RoadMap. All rights reserved.

@testable import MovieMVP
import XCTest

/// Тестирование методов для информаии о фильме
final class MockDetailMoviesTest: XCTestCase {
    // MARK: - Constants

    private enum Constants {
        static let movieID = 355_122
    }

    // MARK: - Private Properties

    private var view: MockDetailMoviesView!
    private var presenter: DetailMoviesViewable!
    private var networkService: NetworkServicable!
    private var realmService: RealmServicable!
    private var imageService: ImageServicable!
    private var keyChainService: KeychainServicable!
    private var routerProtocol: Routerable!
    private var movieInfo = Movies()

    // MARK: - Public Methods

    override func setUp() {
        let navigationController = UINavigationController()
        let builder = Builder()
        routerProtocol = Router(navigationController: navigationController, builder: builder)
        imageService = ImageService()
        keyChainService = KeychainService()
        realmService = RealmService()
    }

    func testGetSuccessMovieInfo() {
        networkService = MockNetworkService(movieInfo: movieInfo)
        let movieID = Constants.movieID
        view = MockDetailMoviesView()
        var catchMovieInfo: Movies?

        networkService.fetchDetailMovies(id: movieID) { result in
            switch result {
            case let .success(movie):
                catchMovieInfo = movie
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        XCTAssertNotNil(catchMovieInfo)
    }

    func testGetFailureMovieInfo() {
        view = MockDetailMoviesView()
        networkService = MockNetworkService(movieInfo: nil)
        var catchError: Error?
        networkService.fetchDetailMovies(id: Constants.movieID) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }
}
