// Actor.swift
// Copyright © RoadMap. All rights reserved.

import SwiftyJSON

/// Модель для получения актеров и их имен
struct Actor {
    /// Имя Актера
    let name: String?
    /// Фото Актера
    let actorImage: String?

    init(json: JSON) {
        name = json["name"].stringValue
        actorImage = json["profile_path"].string
    }
}
