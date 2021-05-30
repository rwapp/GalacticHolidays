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
        layer.addSublayer(border)
        border.strokeColor = UIColor(named: "brand")?.cgColor
        setBackgroundImage(image(withColor: .white), for: .normal)

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }

    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
