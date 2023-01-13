// ActorCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Кастомная ячейка коллекции
final class ActorCollectionViewCell: UICollectionViewCell {
    // MARK: Constants

    private enum Constants {
        static let urlImage = "https://image.tmdb.org/t/p/w500"
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

    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }

    // MARK: Public Methods

    func setCellWithValues(actor: Actor) {
        setUI(actorImage: actor.actorImage, actorName: actor.name)
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
            actorNameLabel.bottomAnchor.constraint(equalTo: actorPhotoImageView.topAnchor, constant: Constants.actorNameLabelBottomAnchor),

            actorPhotoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.actorPhotoImageViewBottomAnchor),
            actorPhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.actorPhotoImageViewLeadingAnchor),
            actorPhotoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.actorPhotoImageViewTrailingAnchor),
            actorPhotoImageView.heightAnchor.constraint(equalToConstant: Constants.actorPhotoImageViewHeightAnchor),
        ])
    }

    private func setUI(actorImage: String?, actorName: String?) {
        actorNameLabel.text = actorName
        guard let imageString = actorImage else { return }

        let urlString = "\(NetworkAPI.imageURL)\(imageString)"

        guard let imageURL = URL(string: urlString) else { return }
        getImageData(url: imageURL)
    }

    private func getImageData(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("\(Constants.dataTaskErrorText) - \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print(Constants.dontGetDataText)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.actorPhotoImageView.image = image
                }
            }
        }.resume()
    }
}
