//
//  DODTextfieldView.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/30.
//

import Foundation
import UIKit
class DODTextfieldView: UITextField  {
    var shouldSetupConstraints = true
    var button = DODButtonView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#function)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawLine(startX: 0, toEndingX: Int(frame.maxX), startingY: Int(frame.minY), toEndingY: Int(frame.minY), ofColor: UIColor.dodNavy1, widthOfLine: 1, inView: self)
    }
    @objc func textChanged(_ sender: UITextField) {
        if self.text?.count == 0 {
            print(#function)
            self.button.check()
        } else {
            self.button.check()
        }
    }
    override func updateConstraints() {
        super.updateConstraints()
        
    }
    func drawLine(startX: Int, toEndingX endX: Int, startingY startY: Int, toEndingY endY: Int, ofColor lineColor: UIColor, widthOfLine lineWidth: CGFloat, inView view: UIView) {

        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth

        view.layer.addSublayer(shapeLayer)

    }
    
}
