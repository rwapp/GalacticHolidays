//
//  BookingViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 19/10/2020.
//

import UIKit

class BookingViewController: UIViewController {

    @IBOutlet weak private var submit: UIButton!
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var confirmEmailField: UITextField!
    @IBOutlet weak private var nameField: UITextField!
    @IBOutlet weak private var cardNumberField: UITextField!
    @IBOutlet weak private var cvvField: UITextField!
    @IBOutlet weak private var dobField: UITextField!
    @IBOutlet weak private var loadingView: UIView!
    @IBOutlet weak private var spinnerView: UIView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var clearButton: UIButton!
    @IBOutlet weak private var timeRemainingLabel: UILabel!

    private var timer: Timer?
    weak var activeField: UITextField?

    private let timeoutInterval = 1200
    private lazy var timeoutRemaining = timeoutInterval
    private var resetsRemaining = 2

    private var formComplete: Bool = false {
        didSet {
            submit.isEnabled = formComplete
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        submit.isEnabled = false
        eachTextField(view) {
            $0.delegate = self
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        idleTimer()
        setupRefreshButton()

        title = "Booking"
    }

    private func idleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            self.timeoutRemaining -= 1

            if self.timeoutRemaining == 0 {
                self.showTimeout()
                return
            }

            self.idleTimer()
        }

        let minutes: Int = timeoutRemaining / 60
        let seconds: Int = timeoutRemaining % 60

        var secondsString = "\(seconds)"
        if secondsString.count == 1 {
            secondsString.prepend("0")
        }

        self.timeRemainingLabel.text = "Time remaining: \(minutes):\(secondsString)"
    }

    private func bookingTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            self.performSegue(withIdentifier: "bookingComplete", sender: nil)
        }
    }

    private func showTimeout() {

        let alert = UIAlertController(title: "Timed out", message: nil, preferredStyle: .alert)

        if resetsRemaining > 0 {
            let continueButton = UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
                if let self = self {
                    self.timeoutRemaining = self.timeoutInterval
                    self.idleTimer()
                    self.resetsRemaining -= 1
                }
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(continueButton)
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelButton)

        present(alert, animated: true, completion: nil)
    }

    private func showFormError() {

    }

    private func setupRefreshButton() {
        let refresh = NSTextAttachment()
        refresh.image = UIImage(systemName: "arrow.clockwise")

        clearButton.setAttributedTitle(NSAttributedString(attachment: refresh), for: .normal)
        clearButton.accessibilityLabel = "Reset form"
        clearButton.accessibilityUserInputLabels = ["Reset form", "Reset", "Refresh", "Clear", "Clear form", "Restart"]
    }

    private func clearTextFields() {
        eachTextField(view) {
            $0.text = nil
        }
    }

    private func checkFormComplete() {
        var formComplete = true

        eachTextField(view) {
            if $0.text?.count ?? 0 == 0 {
                formComplete = false
            }
        }

        self.formComplete = formComplete
    }

    private func checkFormValid() -> Bool {
        guard let email = emailField.text,
              let confirmEmail = confirmEmailField.text,
              let name = nameField.text,
              let cardNumber = cardNumberField.text,
              let cvv = cvvField.text,
              let sortCode = sortCodeField.text,
              let dob = dobField.text else { return false }

        if email != confirmEmail { return false }
        if !email.contains("@") { return false }
        if !confirmEmail.contains("@") { return false }

        if name.count < 3 { return false }

        if cardNumber.count != 16 { return false }

        if cvv.count != 3 { return false }
        if cvv.rangeOfCharacter(from: .lowercaseLetters) != .none { return false }

        if sortCode.count != 8 { return false }
        if !charAt(location: 2, is: "-", in: sortCode) { return false }
        if !charAt(location: 5, is: "-", in: sortCode) { return false }

        if dob.count != 10 { return false }
        if !charAt(location: 2, is: "/", in: dob) { return false }
        if !charAt(location: 5, is: "/", in: dob) { return false }

        return true
    }

    private func charAt(location: Int, is character: Character, in string: String) -> Bool {
        let stringChar = string[string.index(string.startIndex, offsetBy: location)]
        return stringChar == character
    }

    @IBAction
    private func bookPressed() {
        if checkFormValid() {
            timer?.invalidate()
            processBooking()
        } else {
            showFormError()
        }
    }

    @IBAction
    private func clearPressed() {
        clearTextFields()
    }

    private func processBooking() {
        loadingView.accessibilityViewIsModal = true
        spinnerView.isAccessibilityElement = true
        spinnerView.accessibilityLabel = "Booking..."
        loadingView.isHidden = false
        UIAccessibility.post(notification: .screenChanged, argument: spinnerView)
        bookingTimer()
    }

    private func eachTextField(_ subview: UIView, _ action: (UITextField) -> Void) {
        for view in subview.subviews {
            if let textField = view as? UITextField {
                action(textField)
            } else {
                eachTextField(view, action)
            }
        }
    }

    @objc
    func keyboardDidShow(notification: Notification) {
        guard let keyboardRect: CGRect = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardRect.size.height

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        if let activeField = activeField {
            var visibleArea = view.frame
            visibleArea.size.height -= keyboardHeight

            if !visibleArea.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }

    @objc
    func keyboardWillHide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }

    private func timedOut() {
        navigationController?.popViewController(animated: true)
    }
}

extension BookingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFormComplete()
        activeField = nil
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
}

private extension String {
    mutating func prepend(_ string: String) {
        self = "\(string)\(self)"
    }
}
