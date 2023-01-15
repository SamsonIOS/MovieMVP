// Actor.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift
import SwiftyJSON

/// Модель для получения актеров и их имен
final class Actor: Object {
    /// Имя Актера
    @Persisted(primaryKey: true) var name: String
    /// Фото Актера
    @Persisted var actorImage: String?
    /// Идентификатор фильма
    @Persisted var id: Int

    convenience init(json: JSON) {
        self.init()
        name = json["name"].stringValue
        actorImage = json["profile_path"].string
    }
}
