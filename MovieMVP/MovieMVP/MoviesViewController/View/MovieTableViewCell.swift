// MovieTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомная ячейка table view
final class MovieTableViewCell: UITableViewCell {
    // MARK: Constants

    private enum Constants {
        static let urlImage = "https://image.tmdb.org/t/p/w500"
        static let initErrorText = "init(coder:) has not been implemented"
        static let filmImageViewCornerRadius: CGFloat = 15
        static let nameFilmLabelSystemFont: CGFloat = 16
        static let nameFilmLabelNumberOfLines = 0
        static let infoFilmLabelSystemFont: CGFloat = 13
        static let ratingViewCornerRadius: CGFloat = 12
        static let ratingLabelSystemFont: CGFloat = 12
        static let filmImageViewLeadingAnchor: CGFloat = 10
        static let filmImageViewTopAnchor: CGFloat = 10
        static let filmImageViewBottomAnchor: CGFloat = -10
        static let filmImageViewHeightAnchor: CGFloat = 210
        static let filmImageViewWidthAnchor: CGFloat = 160
        static let nameFilmLabelTopAnchor: CGFloat = 3
        static let nameFilmLabelLeadingAnchor: CGFloat = 10
        static let nameFilmLabelWidthAnchor: CGFloat = 210
        static let nameFilmLabelHeigthAnchor: CGFloat = 60
        static let infoFilmLabelTopAnchor: CGFloat = 5
        static let infoFilmLabelLeadingAnchor: CGFloat = 10
        static let infoFilmLabelWidthAnchor: CGFloat = 170
        static let infoFilmLabelHeigthAnchor: CGFloat = 150
        static let ratingViewTopAnchor: CGFloat = 0
        static let ratingViewWidthAnchor: CGFloat = 24
        static let ratingViewHeigthAnchor: CGFloat = 24
    }

    // MARK: Private Visual Components

    private let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.filmImageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameFilmLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.nameFilmLabelSystemFont, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Constants.nameFilmLabelNumberOfLines
        return label
    }()

    private let infoFilmLabel: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: Constants.infoFilmLabelSystemFont, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .black
        return label
    }()

    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.ratingViewCornerRadius
        view.clipsToBounds = true
        return view
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: Constants.ratingLabelSystemFont, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.initErrorText)
    }

    // MARK: Public Methods

    func setCellWithValues(_ movie: Movies, imageService: ImageServicable) {
        nameFilmLabel.text = movie.title

        infoFilmLabel.text = movie.overview

        guard let rating = movie.rating else { return }
        ratingLabel.text = String(rating)
        guard let imageString = movie.movieImage else { return }
        let urlString = "\(NetworkAPI.imageURL)\(imageString)"
        fetchImage(imageService: imageService, urlString: urlString)
    }

    override func prepareForReuse() {
        filmImageView.image = nil
        infoFilmLabel.text = nil
        ratingLabel.text = nil
    }

    // MARK: Private Methods

    private func fetchImage(imageService: ImageServicable, urlString: String) {
        imageService.photo(byUrl: urlString) { [weak self] result in
            guard let result = result,
                  let self = self else { return }
            if let image = UIImage(data: result) {
                self.filmImageView.image = image
            }
        }
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.filmImageViewLeadingAnchor
            ),
            filmImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.filmImageViewTopAnchor),
            filmImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.filmImageViewBottomAnchor),
            filmImageView.heightAnchor.constraint(equalToConstant: Constants.filmImageViewHeightAnchor),
            filmImageView.widthAnchor.constraint(equalToConstant: Constants.filmImageViewWidthAnchor),

            nameFilmLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.nameFilmLabelTopAnchor),
            nameFilmLabel.leadingAnchor.constraint(
                equalTo: filmImageView.trailingAnchor,
                constant: Constants.nameFilmLabelLeadingAnchor
            ),
            nameFilmLabel.widthAnchor.constraint(equalToConstant: Constants.nameFilmLabelWidthAnchor),
            nameFilmLabel.heightAnchor.constraint(equalToConstant: Constants.nameFilmLabelHeigthAnchor),

            infoFilmLabel.topAnchor.constraint(
                equalTo: nameFilmLabel.bottomAnchor,
                constant: Constants.infoFilmLabelTopAnchor
            ),
            infoFilmLabel.leadingAnchor.constraint(
                equalTo: filmImageView.trailingAnchor,
                constant: Constants.infoFilmLabelLeadingAnchor
            ),
            infoFilmLabel.widthAnchor.constraint(equalToConstant: Constants.infoFilmLabelWidthAnchor),
            infoFilmLabel.heightAnchor.constraint(equalToConstant: Constants.infoFilmLabelHeigthAnchor),

            ratingView.leadingAnchor.constraint(equalTo: filmImageView.leadingAnchor),
            ratingView.topAnchor.constraint(equalTo: filmImageView.topAnchor, constant: Constants.ratingViewTopAnchor),
            ratingView.widthAnchor.constraint(equalToConstant: Constants.ratingViewWidthAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: Constants.ratingViewHeigthAnchor),

            ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor)
        ])
    }

    private func setupView() {
        backgroundColor = .black
        addSubview(filmImageView)
        addSubview(nameFilmLabel)
        addSubview(infoFilmLabel)
        addSubview(ratingView)
        addSubview(ratingLabel)
    }
}
