// RealmService.swift
// Copyright © RoadMap. All rights reserved.

import RealmSwift

/// Realm Service
final class RealmService: RealmServicable {
    let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

    func save<T: Object>(items: [T], update: Bool = true) {
        do {
            let realm = try Realm(configuration: deleteIfMigration)
            try realm.write {
                realm.add(items, update: .modified)
            }

        } catch {
            print(error.localizedDescription)
        }
    }

    func get<T: Object>(_ type: T.Type, requestType: RequestType) -> RealmSwift.Results<T>? {
        do {
            let realm = try Realm(configuration: deleteIfMigration)
            let object = realm.objects(T.self).filter("requestType = %@", requestType.rawValue)
            return object
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func getActors<T: Object>(_ type: T.Type, id: Int) -> RealmSwift.Results<T>? {
        do {
            let realm = try Realm(configuration: deleteIfMigration)
            let object = realm.objects(T.self).filter("id = %@", id)
            return object
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
