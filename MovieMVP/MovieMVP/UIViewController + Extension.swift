//
//  UIViewController + Extension.swift
//  MovieMVP
//
//  Created by coder on 13.01.2023.
//

import UIKit

/// Расширение для UIViewController(Alert)
private enum Constant {
    static let okTextString = "OK"
}

extension UIViewController {
    typealias Closure = (() -> ())?
    func showAlert(title: String?, message: String, handler: Closure) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertControllerAction = UIAlertAction(title: Constant.okTextString, style: .default) { _ in
            handler?()
        }
        alertController.addAction(alertControllerAction)
        present(alertController, animated: true)
    }
}
