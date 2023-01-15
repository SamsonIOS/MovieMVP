// MoviesPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Презентер каталога фильмов
final class MoviesPresenter: MoviesPresentable {
    // MARK: - Public Properties

    weak var view: MoviesViewProtocol?
    var router: Routerable?
    var movies: [Movies] = []

    // MARK: - Private Properties

    private let networkService: NetworkServicable
    private var realmService: RealmService
    var imageService: ImageServicable

    // MARK: - Init

    init(
        view: MoviesViewProtocol?,
        networkService: NetworkServicable,
        router: Routerable,
        realmService: RealmService,
        imageService: ImageServicable
    ) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.realmService = realmService
        self.imageService = imageService
        loadMovies(requestType: .popular)
    }

    // MARK: - Public methods

    func fetchMovies(requestType: RequestType) {
        networkService.fetchMovies(requestType: requestType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.movies += data
                data.forEach { movie in
                    movie.requestType = requestType.rawValue
                }
                self.realmService.save(items: self.movies)
                self.view?.succes()
            case let .failure(error):
                self.view?.failure(error)
            }
        }
    }

    func loadMovies(requestType: RequestType) {
        guard let movies = realmService.get(Movies.self, requestType: requestType) else { return }
        if !movies.isEmpty {
            self.movies = Array(movies)
            view?.succes()
        } else {
            fetchMovies(requestType: requestType)
        }
    }

    func switchMovies(tag: Int) {
        switch tag {
        case 0:
            loadMovies(requestType: .popular)
        case 1:
            loadMovies(requestType: .topRated)
        case 2:
            loadMovies(requestType: .upcoming)
        default:
            break
        }
    }

    func cellForRowAt(indexPath: IndexPath) -> Movies {
        movies[indexPath.row]
    }

    func selectMovie(id: Int) {
        router?.showDetailMoviesViewController(id: id)
    }
}
