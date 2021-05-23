//
//  SuccessViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 23/04/2021.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var backButton: UIButton!
    @IBOutlet weak private var referenceLabel: UILabel!
    @IBOutlet weak private var titleContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "space")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .white

        let reference = "123ABC456"
        let referenceString = NSMutableAttributedString(string: "Booking ref: ")
        let attributedReference = NSAttributedString(string: reference, attributes: [.accessibilitySpeechSpellOut: true])
        referenceString.append(attributedReference)
        referenceLabel.attributedText = referenceString

        let backButtonTitle = NSAttributedString(string: "Go back home", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        backButton.titleLabel?.attributedText = backButtonTitle
        backButton.accessibilityTraits.insert(.link)
        backButton.accessibilityTraits.remove(.button)

        titleContainer.isAccessibilityElement = true
        titleContainer.accessibilityTraits.insert(.header)
        titleContainer.accessibilityLabel = "You're going!"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func homePressed() {
        navigationController?.popToRootViewController(animated: true)
    }
}
