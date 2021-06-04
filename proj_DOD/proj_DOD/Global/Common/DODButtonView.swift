//
//  DODbuttonView.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/30.
//

import Foundation
import UIKit
class DODButtonView: BaseUIView {
    var button = UIButton()
    var isEnabled = false
    override func setupView() {
        super.setupView()
        
    }
    func check() {
        if !isEnabled {
            self.button.isEnabled = false
        } else {
            self.button.isEnabled = true
        }
    }
    
}
