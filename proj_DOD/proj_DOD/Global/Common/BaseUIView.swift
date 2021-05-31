//
//  BaseUIView.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/26.
//

import Foundation
import UIKit
class BaseUIView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setupView() { }
}
