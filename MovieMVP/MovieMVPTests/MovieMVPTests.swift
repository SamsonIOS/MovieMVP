// MovieMVPTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import MovieMVP
import XCTest

/// Тесты приложения
final class MoviesListTest: XCTestCase {
    // MARK: - Constants
    private enum Constants {
        static let countMovies = 20
    }
    // MARK: - Private Properties

    private var view: MockMovieView!
    private var presenter: MoviesPresenter!
    private var networkService: NetworkServicable!
    private var realmService: RealmServicable!
    private var imageService: ImageServicable!
    private var keyChainService: KeychainServicable!
    private var routerProtocol: Routerable!
    private var movie: [Movies] = []

    // MARK: - Public Methods

    override func setUp() {
        let navigationController = UINavigationController()
        let builder = Builder()
        routerProtocol = Router(navigationController: navigationController, builder: builder)
        imageService = ImageService()
        keyChainService = KeychainService()
        realmService = RealmService()
        networkService = MockNetworkService()
    }

    func testGetSuccessMovies() {
        view = MockMovieView()
        networkService = MockNetworkService(movie: movie)
        realmService = MockRealmService()
        var catchMovie: [Movies] = []

        networkService.fetchMovies(requestType: .popular) { result in
            switch result {
            case let .success(movie):
                catchMovie = movie
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        XCTAssertEqual(catchMovie.count, Constants.countMovies)
    }

    func testGetFailureMovies() {
        view = MockMovieView()
        networkService = MockNetworkService(movie: nil)
        var catchError: Error?
        networkService.fetchMovies(requestType: .popular) { result in
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
