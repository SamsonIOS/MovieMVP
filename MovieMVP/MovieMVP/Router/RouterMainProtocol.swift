// RouterMainProtocol.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол основного роутера
protocol RouterMainProtocol {
    var navigationController: UINavigationController? { get set }
    var builder: Builderable? { get set }
}
