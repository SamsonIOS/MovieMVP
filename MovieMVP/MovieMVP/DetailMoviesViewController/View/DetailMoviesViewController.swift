// DetailMoviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран с подробной информацией о фильме
final class DetailMoviesViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let collectionCellId = "CollectionCell"
        static let responseText = "Response"
        static let dontGetDataText = "Данные не получены"
        static let buttonTitle = "К Списку"
        static let dataTaskErrorText = "DataTask error:"
        static let itemSizeWidth = 170
        static let itemSizeHeight = 230
        static let minimumLineSpacing: CGFloat = 18
        static let sectionInsetTop: CGFloat = 10
        static let sectionInsetLeft: CGFloat = 5
        static let sectionInsetBottom: CGFloat = 10
        static let sectionInsetRight: CGFloat = 5
        static let movieImageViewBorderWidth: CGFloat = 1
        static let dateLabelSystemFont: CGFloat = 18
        static let overviewLabelSystemFont: CGFloat = 15
        static let overviewLabelMaximumNumberOfLines = 0
        static let movieImageViewTopAnchor: CGFloat = 100
        static let movieImageViewHeightAnchor: CGFloat = 250
        static let dateLabelTopAnchor: CGFloat = 20
        static let overviewLabelTopAnchor: CGFloat = 30
        static let overviewLabelLeadingAnchor: CGFloat = 10
        static let overviewLabelTrailingAnchor: CGFloat = -10
        static let overviewLabelHeightAnchor: CGFloat = 160
        static let collectionViewTopAnchor: CGFloat = 5
        static let collectionViewLeadingAnchor: CGFloat = 10
        static let collectionViewTrailingAnchor: CGFloat = -10
        static let collectionViewBottomAnchor: CGFloat = -10
        static let detailMoviesID = "detailMovies"
        static let detailMoviesCellID = "detailMoviesCell"
    }

    // MARK: - Private Visual Components

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Constants.itemSizeWidth, height: Constants.itemSizeHeight)
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(
            top: Constants.sectionInsetTop,
            left: Constants.sectionInsetLeft,
            bottom: Constants.sectionInsetBottom,
            right: Constants.sectionInsetRight
        )
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionCellId)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .black
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = Constants.movieImageViewBorderWidth
        imageView.layer.borderColor = UIColor.orange.cgColor
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.dateLabelSystemFont, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    private let overviewLabel: UITextView = {
        let label = UITextView()
        label.font = .monospacedDigitSystemFont(ofSize: Constants.overviewLabelSystemFont, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .black
        label.textContainer.maximumNumberOfLines = Constants.overviewLabelMaximumNumberOfLines
        label.isEditable = false
        label.isSelectable = false
        label.textContainer.lineBreakMode = .byCharWrapping
        return label
    }()

    // MARK: - Public properties

    var presenter: DetailMoviesable?

    // MARK: - Private properties

    private var actor: [Actor] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private var movieId: Int?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    // MARK: - Public Methods

    func setUI(movie: Movies?, imageURL: String, imageService: ImageServicable) {
        dateLabel.text = movie?.date
        overviewLabel.text = movie?.overview
        movieId = movie?.id
        title = movie?.title
        let urlString = "\(NetworkAPI.imageURL)\(imageURL)"
        fetchImage(imageService: imageService, urlString: urlString)
    }

    // MARK: - Private Methods

    private func fetchImage(imageService: ImageServicable, urlString: String) {
        imageService.photo(byUrl: urlString) { [weak self] result in
            guard let result = result,
                  let self = self else { return }
            if let image = UIImage(data: result) {
                self.movieImageView.image = image
            }
        }
    }

    private func setView() {
        view.backgroundColor = .black
        view.addSubview(movieImageView)
        view.addSubview(dateLabel)
        view.addSubview(overviewLabel)
        view.addSubview(collectionView)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationController?.navigationBar.topItem?.title = Constants.buttonTitle
        collectionView.backgroundColor = .black
        setConstraints()
        fetchDetailMovies()
        view.accessibilityIdentifier = Constants.detailMoviesID
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.movieImageViewTopAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: Constants.movieImageViewHeightAnchor),

            dateLabel.topAnchor.constraint(
                equalTo: movieImageView.bottomAnchor,
                constant: Constants.dateLabelTopAnchor
            ),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            overviewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overviewLabel.topAnchor.constraint(
                equalTo: dateLabel.topAnchor,
                constant: Constants.overviewLabelTopAnchor
            ),
            overviewLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.overviewLabelLeadingAnchor
            ),
            overviewLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.overviewLabelTrailingAnchor
            ),
            overviewLabel.heightAnchor.constraint(equalToConstant: Constants.overviewLabelHeightAnchor),

            collectionView.topAnchor.constraint(
                equalTo: overviewLabel.bottomAnchor,
                constant: Constants.collectionViewTopAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.collectionViewLeadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.collectionViewTrailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: Constants.collectionViewBottomAnchor
            )
        ])
    }

    private func fetchDetailMovies() {
        presenter?.fetchDetailMovies()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DetailMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.actors.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.collectionCellId,
            for: indexPath
        ) as? ActorCollectionViewCell else { return UICollectionViewCell() }
        guard let actor = presenter?.actors[indexPath.row],
              let imageService = presenter?.imageService,
              let actorImage = actor.actorImage
        else { return UICollectionViewCell() }
        cell.setCellWithValues(actor: actor, imageURL: actorImage, imageService: imageService)
        cell.layer.cornerRadius = 5
        cell.accessibilityIdentifier = Constants.detailMoviesCellID
        cell.clipsToBounds = true
        return cell
    }
}

// MARK: - DetailMoviesViewable

extension DetailMoviesViewController: DetailMoviesViewable {
    func succes() {
        collectionView.reloadData()
    }

    func failure(_ error: Error) {
        showAlert(title: nil, message: error.localizedDescription, handler: nil)
    }

    func setupUI(movieDetail: Movies?, imageURL: String, imageService: ImageServicable) {
        setUI(movie: movieDetail, imageURL: imageURL, imageService: imageService)
    }
}
