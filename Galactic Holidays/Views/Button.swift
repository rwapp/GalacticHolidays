//
//  Button.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 24/04/2021.
//

import UIKit

class Button: UIButton {

    override func draw(_ rect: CGRect) {
        let border = CAShapeLayer()
        let cornerRadius: CGFloat = 10

        border.lineWidth = 3
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(border)
        border.strokeColor = UIColor(named: "brand")?.cgColor

        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true

    }
}
