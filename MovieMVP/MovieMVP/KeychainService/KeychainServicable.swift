// KeychainServicable.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для кейчена
protocol KeychainServicable {
    func setAPI(value: String, forKey: String)
    func getAPI(key: String) -> String
}
