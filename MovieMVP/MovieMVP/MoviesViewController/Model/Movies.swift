// Movies.swift
// Copyright © RoadMap. All rights reserved.

import SwiftyJSON

/// Модель для получении информации о фильмах
struct Movies {
    /// Название
    let title: String?
    /// Описание фильма
    let overview: String?
    /// Постер
    let movieImage: String?
    /// Рейтинг
    let rating: Double?
    /// Идентификатор
    let id: Int?
    /// Постер фильма для второго экрана
    let backdropImage: String?
    /// Дата выхода
    let date: String?

    init(json: JSON) {
        title = json["title"].stringValue
        overview = json["overview"].stringValue
        movieImage = json["poster_path"].string
        backdropImage = json["backdrop_path"].string
        rating = json["vote_average"].doubleValue
        id = json["id"].intValue
        date = json["release_date"].stringValue
    }
}
