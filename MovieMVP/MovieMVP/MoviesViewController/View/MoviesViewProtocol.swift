// MoviesViewProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для презентера
protocol MoviesViewProtocol: AnyObject {
    func succes()
    func failure(_ error: Error)
}
