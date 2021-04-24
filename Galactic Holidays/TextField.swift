//
//  TextField.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 19/10/2020.
//

import UIKit

class TextField: UITextField {

    private var line: UIView?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        borderStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        line?.removeFromSuperview()
        let lineFrame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
        let line = UIView(frame: lineFrame)
        line.backgroundColor = UIColor(named: "brand")

        addSubview(line)
        self.line = line
    }
}
