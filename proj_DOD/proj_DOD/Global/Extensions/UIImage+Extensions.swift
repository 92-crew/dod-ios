//
//  UIImage+Extensions.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/30.
//

import Foundation
import UIKit
extension UIImage {
    func  resizedImage(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image{ _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
