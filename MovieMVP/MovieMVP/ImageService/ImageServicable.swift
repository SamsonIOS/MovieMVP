// ImageServicable.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол для фото сервиса
protocol ImageServicable {
    func photo(byUrl url: String, completion: @escaping ((Data?) -> ()))
}
