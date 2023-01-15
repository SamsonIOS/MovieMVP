// KeychainService.swift
// Copyright © RoadMap. All rights reserved.

import KeychainSwift

/// Сервис шифровки данных
final class KeychainService: KeychainServicable {
    // MARK: - Private properties

    private let keychain = KeychainSwift()

    // MARK: - Public methods

    func setAPI(value: String, forKey: String) {
        keychain.set(value, forKey: forKey)
    }

    func getAPI(key: String) -> String {
        guard let keyValue = keychain.get(key) else { return String() }
        return keyValue
    }
}
