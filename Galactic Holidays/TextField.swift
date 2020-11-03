//
//  TextField.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 19/10/2020.
//

import UIKit

class TextField: UITextField {

    override func draw(_ rect: CGRect) {
        borderStyle = .none

        let lineFrame = CGRect(x: 0, y: rect.size.height - 10, width: rect.size.width, height: 1)
        let line = UIView(frame: lineFrame)
        line.backgroundColor = .blue

        addSubview(line)
    }

}
