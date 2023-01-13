// DetailMoviesViewProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол детального описания фильма
protocol DetailMoviesViewable: AnyObject {
    func succes()
    func failure(_ error: Error)
    func setupUI(movieDetail: Movies?, imageURL: String)
}
