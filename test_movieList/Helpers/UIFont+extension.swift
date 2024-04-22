//
//  UIFont+extension.swift
//  test_movieList
//
//  Created by User on 22.04.2024.
//

import Foundation
import UIKit

extension UIFont {
    static func lotaBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "LotaGrotesque-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func lotaRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "LotaGrotesque-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
