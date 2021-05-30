//
//  ReviewViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 23/05/2021.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLine1Label: UILabel!
    @IBOutlet private weak var addressLine2Label: UILabel!
    @IBOutlet private weak var addressLine3Label: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var postcodeLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var expiryLabel: UILabel!
    @IBOutlet private weak var cvvLabel: UILabel!
    @IBOutlet private weak var dobLabel: UILabel!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet weak private var spinnerView: UIView!

    var customerData: CustomerData?
    private var timer: Timer?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = customerData?.name
        addressLine1Label.text = customerData?.address1
        addressLine2Label.text = customerData?.address2
        addressLine3Label.text = customerData?.address3
        cityLabel.text = customerData?.city
        postcodeLabel.attributedText = NSAttributedString(string: customerData?.postcode ?? "",
                                                          attributes: [.accessibilitySpeechSpellOut: true])
        emailLabel.text = customerData?.email
        cardNumberLabel.text = customerData?.cardNo
        expiryLabel.text = customerData?.expiry
        cvvLabel.attributedText = NSAttributedString(string: customerData?.cvv ?? "",
                                                     attributes: [.accessibilitySpeechSpellOut: true])
        dobLabel.text = customerData?.dob
    }

    @IBAction func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func bookPressed() {
        loadingView.accessibilityViewIsModal = true
        spinnerView.isAccessibilityElement = true
        spinnerView.accessibilityLabel = NSLocalizedString("REVIEW_SCREEN.BOOKING",
                                                           comment: "")
        loadingView.isHidden = false
        UIAccessibility.post(notification: .screenChanged, argument: spinnerView)
        bookingTimer()
    }

    private func bookingTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            self.performSegue(withIdentifier: "bookingComplete", sender: nil)
        }
    }
}
