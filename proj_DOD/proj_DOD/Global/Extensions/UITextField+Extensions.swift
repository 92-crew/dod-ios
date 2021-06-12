//
//  UITextField+Extensions.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/04/11.
//

import UIKit

extension UITextField{
    func addLeftPadding(left: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
    
    func setUnderLined() {
        let underLine: UIView = {
            let view = UIView()
            view.backgroundColor = .dodNavy1
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        addSubview(underLine)
        
        NSLayoutConstraint.activate([
            underLine.heightAnchor.constraint(equalToConstant: 2),
            underLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            underLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            underLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
