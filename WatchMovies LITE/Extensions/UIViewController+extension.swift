//
//  UIViewController+extension.swift
//  test_movieList
//
//  Created by User on 30.04.2024.
//

import Foundation
import UIKit
import SafariServices
import StoreKit

extension UIViewController {
    func showAlertDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

import StoreKit

extension UIViewController {
    func showRateAndSupportActionSheet(completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let rateAction = UIAlertAction(title: "Rate Us", style: .default) { [weak self] _ in
            self?.openAppStoreForRating()
        }
        let contactSupportAction = UIAlertAction(title: "Contact Support", style: .default) { [weak self] _ in
            self?.openSupportPage()
        }
        let deleteBookmarksAction = UIAlertAction(title: "Delete All Bookmarks", style: .destructive) { [weak self] _ in
            FavoritesManager.shared.deleteAllFavorites {
                completion?() 
                self?.showAlertDialog(title: "Success", message: "All bookmarks have been deleted.")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(rateAction)
        alertController.addAction(contactSupportAction)
        alertController.addAction(deleteBookmarksAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func openAppStoreForRating() {
        if let windowScene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func openSupportPage() {
        if let url = URL(string: "https://forms.gle/cqrBN7XV8VjKCvhB6") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
