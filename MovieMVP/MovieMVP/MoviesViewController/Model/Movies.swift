// Movies.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift
import SwiftyJSON

/// Модель для получении информации о фильмах
final class Movies: Object {
    /// Идентификатор
    @Persisted(primaryKey: true) var id: Int?
    /// Название
    @Persisted var title: String?
    /// Описание фильма
    @Persisted var overview: String?
    /// Постер
    @Persisted var movieImage: String?
    /// Рейтинг
    @Persisted var rating: Double?
    /// Постер фильма для второго экрана
    @Persisted var backdropImage: String?
    /// Дата выхода
    @Persisted var date: String?
    /// Типы фильмов
    @Persisted var requestType: String?

    convenience init(json: JSON) {
        self.init()
        title = json["title"].stringValue
        overview = json["overview"].stringValue
        movieImage = json["poster_path"].string
        backdropImage = json["backdrop_path"].string
        rating = json["vote_average"].doubleValue
        id = json["id"].intValue
        date = json["release_date"].stringValue
        requestType = ""
    }
}
