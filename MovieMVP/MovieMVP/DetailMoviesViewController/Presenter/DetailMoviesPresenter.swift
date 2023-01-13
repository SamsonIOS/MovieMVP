// DetailMoviesPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Презентер детального описания фильма
final class DetailMoviesPresenter: DetailMoviesable {
    // MARK: - Public Properties

    weak var view: DetailMoviesViewable?
    var router: Routerable?
    var detailMovies: Movies?
    var actors: [Actor] = []

    // MARK: - Private Properties

    private let networkService: NetworkServicable
    private var movieId = 0

    // MARK: - Initializers

    init(view: DetailMoviesViewable?, networkService: NetworkServicable, id: Int, router: Routerable) {
        self.view = view
        self.networkService = networkService
        self.router = router
        movieId = id
    }

    // MARK: - Public methods

    func fetchDetailMovies() {
        networkService.fetchDetailMovies(id: movieId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movieDetail):
                self.detailMovies = movieDetail
                self.view?.setupUI(movieDetail: movieDetail, imageURL: movieDetail.backdropImage ?? "")
            case let .failure(error):
                self.view?.failure(error)
            }
        }
    }

    func fetchActor() {
        networkService.fetchActorData(actorsID: movieId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(actors):
                self.actors = actors
                self.view?.succes()
            case let .failure(error):
                self.view?.failure(error)
            }
        }
    }
}
