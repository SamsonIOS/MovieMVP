// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Scene Delegate
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Public Properties

    var window: UIWindow?

    // MARK: - Public Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScence = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScence.coordinateSpace.bounds)
        window?.windowScene = windowScence
        let navigationController = UINavigationController()
        let builder = Builder()
        let router = Router(navigationController: navigationController, builder: builder)
        router.moviesViewController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
