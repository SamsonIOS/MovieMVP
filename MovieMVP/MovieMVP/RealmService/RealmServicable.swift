// RealmServicable.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift

/// Протокол для реалма
protocol RealmServicable {
    func save<T: Object>(items: [T], update: Bool)
    func get<T: Object>(_ type: T.Type, requestType: RequestType) -> Results<T>?
    func getActors<T: Object>(_ type: T.Type, id: Int) -> Results<T>?
}
