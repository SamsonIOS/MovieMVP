// MoviesPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Презентер каталога фильмов
final class MovieCatalogPresenter: MoviesPresentable {
    // MARK: - Public Properties

    weak var view: MoviesViewProtocol?
    var router: Routerable?
    var movies: [Movies] = []

    // MARK: - Private Properties

    private let networkService: NetworkServicable
    private var hasNextPage = true
    private var currentPage = 1
    private var currentRequestType: RequestType = .popular

    // MARK: - Init

    init(view: MoviesViewProtocol?, networkService: NetworkServicable, router: Routerable) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }

    // MARK: - Public methods

    func fetchMovies(requestType: RequestType) {
        networkService.fetchMovies(page: currentPage, requestType: requestType, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.movies += data
                self.view?.succes()
            case let .failure(error):
                self.view?.failure(error)
            }
        })
    }

    func cellForRowAt(indexPath: IndexPath) -> Movies {
        movies[indexPath.row]
    }

    func selectMovie(id: Int) {
        router?.showDetailMoviesViewController(id: id)
    }
}
