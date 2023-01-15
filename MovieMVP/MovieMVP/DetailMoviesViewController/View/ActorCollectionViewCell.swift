// ActorCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомная ячейка коллекции
final class ActorCollectionViewCell: UICollectionViewCell {
    // MARK: Constants

    private enum Constants {
        static let dataTaskErrorText = "DataTask error: "
        static let responseText = "Response"
        static let dontGetDataText = "Данные не получены"
        static let initErrorText = "init(coder:) has not been implemented"
        static let actorPhotoImageViewCornerRadius: CGFloat = 5
        static let actorPhotoImageViewBorderWidth: CGFloat = 1
        static let actorNameLabelSystemFont: CGFloat = 13
        static let actorNameLabelTopAnchor: CGFloat = 2
        static let actorNameLabelBottomAnchor: CGFloat = 2
        static let actorPhotoImageViewBottomAnchor: CGFloat = -5
        static let actorPhotoImageViewLeadingAnchor: CGFloat = 4
        static let actorPhotoImageViewTrailingAnchor: CGFloat = -4
        static let actorPhotoImageViewHeightAnchor: CGFloat = 200
    }

    // MARK: Private Visual Components

    private let actorPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = Constants.actorPhotoImageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = Constants.actorPhotoImageViewBorderWidth
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let actorNameLabel: UILabel = {
        let name = UILabel()
        name.textColor = .white
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: Constants.actorNameLabelSystemFont, weight: .semibold)
        return name
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.initErrorText)
    }

    // MARK: Public Methods

    override func prepareForReuse() {
        actorPhotoImageView.image = nil
        actorNameLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }

    func setCellWithValues(actor: Actor, imageURL: String, imageService: ImageServicable) {
        actorNameLabel.text = actor.name
        let urlString = "\(NetworkAPI.imageURL)\(imageURL)"
        fetchActorsImage(imageService: imageService, urlString: urlString)
    }

    // MARK: Private Methods

    private func setupViews() {
        addSubview(actorPhotoImageView)
        addSubview(actorNameLabel)
        backgroundColor = .black
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            actorNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            actorNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.actorNameLabelTopAnchor),
            actorNameLabel.bottomAnchor.constraint(
                equalTo: actorPhotoImageView.topAnchor,
                constant: Constants.actorNameLabelBottomAnchor
            ),

            actorPhotoImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: Constants.actorPhotoImageViewBottomAnchor
            ),
            actorPhotoImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.actorPhotoImageViewLeadingAnchor
            ),
            actorPhotoImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: Constants.actorPhotoImageViewTrailingAnchor
            ),
            actorPhotoImageView.heightAnchor.constraint(equalToConstant: Constants.actorPhotoImageViewHeightAnchor),
        ])
    }

    private func fetchActorsImage(imageService: ImageServicable, urlString: String) {
        imageService.photo(byUrl: urlString) { [weak self] result in
            guard let result = result,
                  let self = self else { return }
            if let image = UIImage(data: result) {
                self.actorPhotoImageView.image = image
            }
        }
    }
}
