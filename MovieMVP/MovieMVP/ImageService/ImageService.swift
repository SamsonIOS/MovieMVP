// ImageService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import Foundation

/// Фото сервис
final class ImageService: ImageServicable {
    // MARK: - Private Constants

    private enum Constants {
        static let defaultText = "default"
        static let imagesText = "MoviesImages"
        static let separatorText: Character = "/"
        static let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    }

    // MARK: - Private Properies

    private let cacheLifeTime: TimeInterval = Constants.cacheLifeTime

    private static let pathName: String = {
        let pathName = Constants.imagesText
        guard let cachesDirectory = FileManager.default.urls(
            for:
            .cachesDirectory,
            in: .userDomainMask
        ).first else { return pathName }

        let url = cachesDirectory.appendingPathComponent(
            pathName,
            isDirectory:
            true
        )
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        return pathName
    }()

    private var imagesMap = [String: Data]()

    // MARK: - Public Methods

    func photo(byUrl url: String, completion: @escaping ((Data?) -> ())) {
        if let photo = imagesMap[url] {
            completion(photo)
        } else if let photo = getImageFromCache(url: url) {
            completion(photo)
        } else {
            loadPhoto(byUrl: url) { image in
                completion(image)
            }
        }
    }

    // MARK: - Private Methods

    private func loadPhoto(byUrl url: String, completion: @escaping ((Data?) -> ())) {
        AF.request(url).responseData { [weak self] response in
            guard let data = response.data,
                  let self = self else { return }
            DispatchQueue.main.async {
                self.imagesMap[url] = data
            }
            self.saveImageToCache(url: url, image: data)
            completion(data)
        }
    }

    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(
            for:
            .cachesDirectory,
            in: .userDomainMask
        ).first else { return nil }
        guard let fileName = url.split(separator: Constants.separatorText).last else { return nil }
        return cachesDirectory.appendingPathComponent(
            "\(ImageService.pathName)\(Constants.separatorText)\(fileName)"
        ).path
    }

    private func saveImageToCache(url: String, image: Data) {
        guard let fileName = getFilePath(url: url) else { return }
        let data = image
        FileManager.default.createFile(
            atPath: fileName,
            contents: data,
            attributes: nil
        )
    }

    private func getImageFromCache(url: String) -> Data? {
        guard let fileName = getFilePath(url: url),
              let urlImage = URL(string: fileName),
              let info = try? FileManager.default.attributesOfItem(
                  atPath:
                  fileName
              ),
              let modificationDate = info[FileAttributeKey.modificationDate] as?
              Date
        else { return nil }
        let lifeTime = Date().timeIntervalSince(modificationDate)
        guard
            lifeTime <= cacheLifeTime,
            let image = try? Data(contentsOf: urlImage) else { return nil }
        DispatchQueue.main.async {
            self.imagesMap[url] = image
        }
        return image
    }
}
