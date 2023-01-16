// MockRealmService.swift
// Copyright © RoadMap. All rights reserved.

@testable import MovieMVP
import RealmSwift

/// Моковый Реалм сервис
final class MockRealmService: RealmServicable {
    // MARK: - Constants

    private enum Constants {
        static let requestTypeFilter = "requestType = %@"
        static let idFilter = "id = %@"
    }

    // MARK: - Private properties

    private let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

    // MARK: - Public Methods

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
            let object = realm.objects(T.self).filter(Constants.requestTypeFilter, requestType.rawValue)
            return object
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func getActors<T: Object>(_ type: T.Type, id: Int) -> RealmSwift.Results<T>? {
        do {
            let realm = try Realm(configuration: deleteIfMigration)
            let object = realm.objects(T.self).filter(Constants.idFilter, id)
            return object
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
