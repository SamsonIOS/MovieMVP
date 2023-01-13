// MoviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран со списком фильмов
final class MoviesViewController: UIViewController {
    // MARK: Constants

    private enum ButtonsTitle {
        static let popular = "Популярные"
        static let topRating = "Топ рейтинга"
        static let upComing = "Новинки"
        static let emptyText = ""
        static let date = "Дата выхода: "
    }

    private enum CellId {
        static let movieCellId = "movieCell"
    }

    private enum ValueComponents {
        static let buttonSystemFont: CGFloat = 10
        static let cornerRadius: CGFloat = 6
        static let popularButtonTag = 0
        static let topRatingButtonTag = 1
        static let latestButtonTag = 2
    }

    // MARK: - Public properties

    var presenter: MoviesPresentable?

    // MARK: Private Visual Components

    private lazy var popularButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle(ButtonsTitle.popular, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: ValueComponents.buttonSystemFont, weight: .bold)
        button.layer.cornerRadius = ValueComponents.cornerRadius
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        button.tag = ValueComponents.popularButtonTag
        return button
    }()

    private lazy var topRatingsButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle(ButtonsTitle.topRating, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: ValueComponents.buttonSystemFont, weight: .bold)
        button.layer.cornerRadius = ValueComponents.cornerRadius
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        button.tag = ValueComponents.topRatingButtonTag
        return button
    }()

    private lazy var latestButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle(ButtonsTitle.upComing, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: ValueComponents.buttonSystemFont, weight: .bold)
        button.layer.cornerRadius = ValueComponents.cornerRadius
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        button.tag = ValueComponents.latestButtonTag
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: CellId.movieCellId)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = ButtonsTitle.emptyText
    }

    // MARK: Action Buttons

    @objc private func clickAction(sender: UIButton) {
        switch sender.tag {
        case 0:
            switchMovies(urlMovies: "\(NetworkAPI.infoURL)\(RequestType.topRated)")
        case 1:
            switchMovies(urlMovies: "\(NetworkAPI.infoURL)\(RequestType.popular)")
        case 2:
            switchMovies(urlMovies: "\(NetworkAPI.infoURL)\(RequestType.upcoming)")
        default:
            break
        }
    }

    // MARK: Private Methods

    private func switchMovies(urlMovies: String) {
        let url = urlMovies
    }

    private func setView() {
        view.addSubview(tableView)
        view.addSubview(popularButton)
        view.addSubview(topRatingsButton)
        view.addSubview(latestButton)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .black
        title = ButtonsTitle.emptyText
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        constraintsTableView()
        setButtons()
        loadPopularMoviesData(requestType: .popular)
    }

    private func constraintsTableView() {
        tableView.topAnchor.constraint(equalTo: popularButton.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setButtons() {
        popularButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        popularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        popularButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        popularButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        topRatingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        topRatingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topRatingsButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        topRatingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        latestButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        latestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        latestButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        latestButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func loadPopularMoviesData(requestType: RequestType) {
        presenter?.fetchMovies(requestType: requestType)
    }

    private func goToDetailMoviesViewController(id: Int) {
        presenter?.selectMovie(id: id)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.movies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellId.movieCellId,
            for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }

        guard let movie = presenter?.cellForRowAt(indexPath: indexPath) else { return UITableViewCell() }
        cell.setCellWithValues(movie)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetailMoviesViewController(id: presenter?.movies[indexPath.row].id ?? 0)
    }
}

// MARK: - MoviesViewProtocol

extension MoviesViewController: MoviesViewProtocol {
    func failure(_ error: Error) {
        print(error.localizedDescription)
    }

    func succes() {
        tableView.reloadData()
    }
}
