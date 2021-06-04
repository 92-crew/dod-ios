//
//  DODCheckBoxView.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/26.
//

import Foundation
import UIKit

class DODCheckBoxView: BaseUIView {
    private var imageView: UIImageView = UIImageView()
    var isSelected: Bool = false
    override func setupView() {
        super.setupView()
        self.addSubview(self.imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         imageView.topAnchor.constraint(equalTo: self.topAnchor),
         imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].forEach{ $0.isActive = true }
        imageView.image = UIImage(named: "checkboxOff")
    }
    func check() {
        if isSelected == true {
            imageView.image = UIImage(named: "checkboxOn")
        } else {
            imageView.image = UIImage(named: "checkboxOff")
        }
    }
    
}
