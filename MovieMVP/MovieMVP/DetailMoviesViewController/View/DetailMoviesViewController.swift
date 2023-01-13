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

    private var actor: [Actor] = []
    private var movieId: Int?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    // MARK: - Public Methods

    func setUI(movie: Movies?, imageURL: String) {
        dateLabel.text = movie?.date
        overviewLabel.text = movie?.overview
        movieId = movie?.id
        title = movie?.title
        let urlString = "\(NetworkAPI.imageURL)\(imageURL)"
        guard let imageURL = URL(string: urlString) else { return }
        movieImageView.image = nil
        getImageData(url: imageURL)
    }

    // MARK: - Private Methods

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
        fetchActor()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 250),

            dateLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            overviewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overviewLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 30),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            overviewLabel.heightAnchor.constraint(equalToConstant: 160),

            collectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    private func fetchDetailMovies() {
        presenter?.fetchDetailMovies()
    }

    private func fetchActor() {
        presenter?.fetchActor()
    }

    private func getImageData(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("\(Constants.dataTaskErrorText) \(error.localizedDescription)")
                return
            }

            guard response != nil else {
                print(Constants.responseText)
                return
            }

            guard let data = data else {
                print(Constants.dontGetDataText)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.movieImageView.image = image
                }
            }
        }.resume()
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
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: Constants.collectionCellId,
                for: indexPath
            ) as? ActorCollectionViewCell
        else { return UICollectionViewCell() }
        guard let actor = presenter?.actors[indexPath.row] else { return UICollectionViewCell() }
        cell.setCellWithValues(actor: actor)
        cell.layer.cornerRadius = 5
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
        print(error.localizedDescription)
    }

    func setupUI(movieDetail: Movies?, imageURL: String) {
        setUI(movie: movieDetail, imageURL: imageURL)
    }
}
