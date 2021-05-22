//
//  ImageCollectionViewCell.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 24/04/2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imageView: UIImageView!

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    var imageDescription: String? {
        didSet {
            imageView.isAccessibilityElement = true
            imageView.accessibilityLabel = imageDescription
            imageView.accessibilityIgnoresInvertColors = true
        }
    }
}
