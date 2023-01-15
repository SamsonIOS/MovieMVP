// DetailMoviesPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Презентер детального описания фильма
final class DetailMoviesPresenter: DetailMoviesable {
    // MARK: - Public Properties

    weak var view: DetailMoviesViewable?
    var router: Routerable?
    var imageService: ImageServicable
    var detailMovies: Movies?
    var actors: [Actor] = []

    // MARK: - Private Properties

    private let networkService: NetworkServicable
    private var realmService: RealmService
    private var movieId = 0

    // MARK: - Initializers

    init(
        view: DetailMoviesViewable?,
        networkService: NetworkServicable,
        id: Int,
        router: Routerable,
        realmService: RealmService,
        imageService: ImageServicable
    ) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.realmService = realmService
        self.imageService = imageService
        movieId = id
        loadActors()
    }

    // MARK: - Public methods

    func fetchDetailMovies() {
        networkService.fetchDetailMovies(id: movieId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movieDetail):
                self.detailMovies = movieDetail
                self.view?.setupUI(
                    movieDetail: movieDetail,
                    imageURL: movieDetail.backdropImage ?? "",
                    imageService: self.imageService
                )
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
                actors.forEach { actor in
                    actor.id = self.movieId
                }
                self.realmService.save(items: self.actors)
            case let .failure(error):
                self.view?.failure(error)
            }
        }
    }

    func loadActors() {
        guard let actors = realmService.getActors(Actor.self, id: movieId) else { return }
        if !actors.isEmpty {
            self.actors = Array(actors)
            view?.succes()
        } else {
            fetchActor()
        }
    }
}
