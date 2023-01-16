// ModuleBuilderTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import MovieMVP
import XCTest

/// Тест билдера
final class ModuleBuilderTest: XCTestCase {
    // MARK: - Constants

    private enum Constants {
        static let movieID = 355_122
    }

    // MARK: - Private Properties

    private var moduleBuilder: Builderable!

    // MARK: - Public Methods

    override func setUpWithError() throws {
        moduleBuilder = Builder()
    }

    override func tearDownWithError() throws {
        moduleBuilder = nil
    }

    func testMakeMoviesListViewController() {
        let router = MockRouter(builderable: MockModuleBuilder())
        let moviesListViewController = moduleBuilder.makeMoviesViewController(router: router)
        XCTAssertTrue(moviesListViewController is MoviesViewController)
    }

    func testMakeMovieInfoViewController() {
        let router = MockRouter(builderable: MockModuleBuilder())
        let movieInfoViewController = moduleBuilder.makeDetailMoviesViewController(
            id: Constants.movieID,
            router: router
        )
        XCTAssertTrue(movieInfoViewController is DetailMoviesViewController)
    }
}
