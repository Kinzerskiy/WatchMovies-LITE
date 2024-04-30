//
//  UIViewController+extension.swift
//  test_movieList
//
//  Created by User on 30.04.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
