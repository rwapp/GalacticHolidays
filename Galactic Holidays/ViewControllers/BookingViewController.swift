//
//  BookingViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 19/10/2020.
//

import UIKit

class BookingViewController: UIViewController {

    @IBOutlet weak private var submit: UIButton!
    @IBOutlet weak private var emailField: TextField!
    @IBOutlet weak private var confirmEmailField: TextField!
    @IBOutlet weak private var nameField: TextField!
    @IBOutlet weak private var cardNumberField: TextField!
    @IBOutlet weak private var cvvField: TextField!
    @IBOutlet weak private var sortCodeField: TextField!
    @IBOutlet weak private var dobField: TextField!
    @IBOutlet weak private var loadingView: UIView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var clearButton: UIButton!

    private var timer: Timer?
    weak var activeField: UITextField?

    private var alert: CustomModalAlert? {
        didSet {
            oldValue?.removeFromSuperview()
        }
    }

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
    }

    private func idleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            self.showTimeout()
            self.clearTextFields()
        }
    }

    private func bookingTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            self.loadingView.isHidden = false
            self.performSegue(withIdentifier: "bookingComplete", sender: nil)
        }
    }

    private func showTimeout() {
        alert = CustomModalAlert(frame: view.frame)
        alert!.delegate = self
        alert!.message = "Timed out"
        alert!.center = view.center
        view.addSubview(alert!)
    }

    private func showFormError() {
        alert = CustomModalAlert(frame: view.frame)
        alert!.delegate = self
        alert!.message = "There is an error in the form."
        alert!.center = view.center
        view.addSubview(alert!)
    }

    private func setupRefreshButton() {
        let refresh = NSTextAttachment()
        refresh.image = UIImage(systemName: "arrow.clockwise")

        clearButton.setAttributedTitle(NSAttributedString(attachment: refresh), for: .normal)
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
        loadingView.isHidden = false
        bookingTimer()
    }

    private func eachTextField(_ subview: UIView, _ action: (TextField) -> Void) {
        for view in subview.subviews {
            if let textField = view as? TextField {
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

extension BookingViewController: CustomModalAlertDelegate {
    func dismiss() {
        alert?.removeFromSuperview()
        timer?.invalidate()
        idleTimer()
    }
}
