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
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var clearButton: UIButton!
    @IBOutlet weak private var timeRemainingLabel: UILabel!
    @IBOutlet weak private var address1Field: UITextField!
    @IBOutlet weak private var address2Field: UITextField!
    @IBOutlet weak private var address3Field: UITextField!
    @IBOutlet weak private var cityField: UITextField!
    @IBOutlet weak private var postcodeField: UITextField!
    @IBOutlet weak private var expiryField: UITextField!
    @IBOutlet weak private var nameError: UILabel!
    @IBOutlet weak private var addressError: UILabel!
    @IBOutlet weak private var cityError: UILabel!
    @IBOutlet weak private var postcodeError: UILabel!
    @IBOutlet weak private var emailError: UILabel!
    @IBOutlet weak private var confirmEmailError: UILabel!
    @IBOutlet weak private var cardNumberError: UILabel!
    @IBOutlet weak private var expiryError: UILabel!
    @IBOutlet weak private var cvvError: UILabel!
    @IBOutlet weak private var dobError: UILabel!

    private var timer: Timer?
    weak var activeField: UITextField?

    private let timeoutInterval = 1200
    private lazy var timeoutRemaining = timeoutInterval
    private var resetsRemaining = 2

    private var formComplete = false

    override func viewDidLoad() {
        super.viewDidLoad()

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
        timeRemainingLabel.accessibilityTraits.insert(.updatesFrequently)
        setupRefreshButton()
        setupForm()

        title = NSLocalizedString("BOOKING_VIEW.TITlE", comment: "")
    }

    private func setupForm() {
        cvvField.keyboardType = .numberPad
        cardNumberField.keyboardType = .numberPad
        emailField.keyboardType = .emailAddress
        confirmEmailField.keyboardType = .emailAddress
        dobField.keyboardType = .numberPad
        expiryField.keyboardType = .numberPad
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

        self.timeRemainingLabel.text = String(format: NSLocalizedString("BOOKING_VIEW.TIME_REMAINING",
                                                                        comment: ""),
                                              minutes,
                                              secondsString)
    }

    private func showTimeout() {

        let alert = UIAlertController(title: NSLocalizedString("BOOKING_VIEW.TIMEOUT_ALERT.TITLE", comment: ""),
                                      message: nil,
                                      preferredStyle: .alert)

        if resetsRemaining > 0 {
            let continueButton = UIAlertAction(title: NSLocalizedString("BOOKING_VIEW.TIMEOUT_ALERT.CONTINUE",
                                                                        comment: ""),
                                               style: .default) { [weak self] _ in
                if let self = self {
                    self.timeoutRemaining = self.timeoutInterval
                    self.idleTimer()
                    self.resetsRemaining -= 1
                }
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(continueButton)
        }

        let cancelButton = UIAlertAction(title: NSLocalizedString("BOOKING_VIEW.TIMEOUT_ALERT.CANCEL",
                                                                  comment: ""),
                                         style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancelButton)

        present(alert, animated: true, completion: nil)
    }

    private func setupRefreshButton() {
        let refresh = NSTextAttachment()
        refresh.image = UIImage(systemName: "arrow.clockwise")

        clearButton.setAttributedTitle(NSAttributedString(attachment: refresh), for: .normal)
        clearButton.accessibilityLabel = NSLocalizedString("BOOKING_VIEW.RESET_FORM",
                                                           comment: "")
        clearButton.accessibilityUserInputLabels = [NSLocalizedString("BOOKING_VIEW.RESET_FORM",
                                                                      comment: ""),
                                                    NSLocalizedString("BOOKING_VIEW.RESET_FORM.INPUT_RESET",
                                                                      comment: ""),
                                                    NSLocalizedString("BOOKING_VIEW.RESET_FORM.INPUT_REFRESH",
                                                                      comment: ""),
                                                    NSLocalizedString("BOOKING_VIEW.RESET_FORM.INPUT_CLEAR",
                                                                      comment: ""),
                                                    NSLocalizedString("BOOKING_VIEW.RESET_FORM.INPUT_CLEAR_FORM",
                                                                      comment: ""),
                                                    NSLocalizedString("BOOKING_VIEW.RESET_FORM.INPUT_RESTART",
                                                                      comment: "")]
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

        let name = checkName()
        let address = checkAddress()
        let postcode = checkPostcode()
        let emailFormat = checkEmailFormat()
        let emailsMatch = emailsMatch()
        let cardNumber = checkCardNumber()
        let dob = checkDOB()
        let cvv = checkCVV()
        let expiry = checkExpiry()

        return emailsMatch &&
            emailFormat &&
            cardNumber &&
            dob &&
            cvv &&
            expiry &&
            name &&
            address &&
            postcode
    }

    private func checkName() -> Bool {
        if nameField.text?.count == 0 {
            errorField(nameField)
            nameError.text = NSLocalizedString("BOOKING_VIEW.NAME_ERROR",
                                               comment: "")
            return false
        }

        nameError.text = nil
        errorField(nameField, clear: true)
        return true
    }

    private func checkAddress() -> Bool {
        if address1Field.text?.count == 0 {
            errorField(address1Field)
            addressError.text = NSLocalizedString("BOOKING_VIEW.ADDRESS_ERROR",
                                                  comment: "")
            return false
        }

        errorField(address1Field, clear: true)
        addressError.text = nil
        return true
    }

    private func checkPostcode() -> Bool {
        if postcodeField.text?.count ?? 0 < 4 {
            errorField(postcodeField)
            postcodeError.text = NSLocalizedString("BOOKING_VIEW.POSTCODE_ERROR",
                                                   comment: "")
            return false
        }

        errorField(postcodeField, clear: true)
        postcodeError.text = nil
        return true
    }

    private func checkCVV() -> Bool {
        if cvvField.text?.count != 3 {
            errorField(cvvField)
            cvvError.text = NSLocalizedString("BOOKING_VIEW.CVV_ERROR",
                                              comment: "")
            return false
        }

        cvvError.text = nil
        errorField(cvvField, clear: true)
        return true
    }

    private func checkEmailFormat() -> Bool {
        if !(emailField.text?.contains("@") ?? false) {
            errorField(emailField)
            emailError.text = NSLocalizedString("BOOKING_VIEW.EMAIL_ERROR",
                                                comment: "")
            return false
        }

        errorField(emailField, clear: true)
        emailError.text = nil
        return true
    }

    private func emailsMatch() -> Bool {
        if emailField.text != confirmEmailField.text {
            errorField(confirmEmailField)
            confirmEmailError.text = NSLocalizedString("BOOKING_VIEW.CONFIRM_EMAIL_ERROR",
                                                       comment: "")
            return false
        }

        confirmEmailError.text = nil
        errorField(confirmEmailField, clear: true)
        return true
    }

    private func checkCardNumber() -> Bool {
        if cardNumberField.text?.count != 16 {
            // perform a Luhn check
            errorField(cardNumberField)
            cardNumberError.text = NSLocalizedString("BOOKING_VIEW.CARD_ERROR",
                                                     comment: "")
            return false
        }

        cardNumberError.text = nil
        errorField(cardNumberField, clear: true)
        return true
    }

    private func checkDOB() -> Bool {
        if dobField.text?.count != 10 {
            // do some extra checks to ensure this is a valid date
            errorField(dobField)
            dobError.text = NSLocalizedString("BOOKING_VIEW.DOB_ERROR",
                                              comment: "")
            return false
        }

        dobError.text = nil
        errorField(dobField, clear: true)
        return true
    }

    private func checkExpiry() -> Bool {
        if expiryField.text?.count != 5 {
            errorField(expiryField)
            expiryError.text = NSLocalizedString("BOOKING_VIEW.EXPIRY_ERROR",
                                                 comment: "")
            return false
        }

        expiryError.text = nil
        errorField(expiryField, clear: true)
        return true
    }

    private func errorField(_ textField: UITextField, clear: Bool = false) {
        textField.layer.cornerRadius = 8.0
        textField.layer.masksToBounds = true
        textField.layer.borderColor = clear ? UIColor.clear.cgColor : UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
    }

    private func charAt(location: Int, is character: Character, in string: String) -> Bool {
        let stringChar = string[string.index(string.startIndex, offsetBy: location)]
        return stringChar == character
    }

    @IBAction
    private func bookPressed() {
        if checkFormValid() {
            timer?.invalidate()
            performSegue(withIdentifier: "reviewBooking", sender: nil)
        } else {
            voFocusError()
        }
    }

    private func voFocusError() {
        var field: UILabel?

        if nameError.text != nil {
            field = nameError
        } else if addressError.text != nil {
            field = addressError
        } else if postcodeError.text != nil {
            field = postcodeError
        } else if emailError.text != nil {
            field = emailError
        } else if confirmEmailError.text != nil {
            field = confirmEmailError
        } else if cardNumberError.text != nil {
            field = cardNumberError
        } else if expiryError.text != nil {
            field = expiryError
        } else if cvvError.text != nil {
            field = cvvError
        } else {
            field = dobError
        }

        UIAccessibility.post(notification: .layoutChanged, argument: field)
    }

    @IBAction
    private func clearPressed() {
        clearTextFields()
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

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 60, right: 0)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ReviewViewController else { return }
        vc.customerData = CustomerData(name: nameField.text!,
                                       address1: address1Field.text!,
                                       address2: address2Field.text,
                                       address3: address3Field.text,
                                       city: cityField.text!,
                                       postcode: postcodeField.text!,
                                       email: emailField.text!,
                                       cardNo: cardNumberField.text!,
                                       expiry: expiryField.text!,
                                       cvv: cvvField.text!,
                                       dob: dobField.text!)
    }
}

extension BookingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.count == 0 {
            // delete
            return true
        }

        if textField == cvvField {
            if string.rangeOfCharacter(from: .decimalDigits) == .none {
                return false
            }
            
            if textField.text?.count ?? 0 >= 3 {
                return false
            }
        }

        if textField == cardNumberField {
            if string.rangeOfCharacter(from: .decimalDigits) == .none {
                return false
            }

            if textField.text?.count ?? 0 >= 16 {
                return false
            }
        }

        if textField == expiryField {

            if string.rangeOfCharacter(from: .decimalDigits) == .none {
                return false
            }

            let count = textField.text?.count ?? 0

            switch count {
            case 2:
                textField.text = textField.text! + "/"
            case 5:
                return false
            default:
                break
            }
        }

        if textField == dobField {

            if string.rangeOfCharacter(from: .decimalDigits) == .none {
                return false
            }

            let count = textField.text?.count ?? 0

            switch count {
            case 2, 5:
                textField.text = textField.text! + "/"
            case 10:
                return false
            default:
                break
            }
        }

        return true
    }
}

private extension String {
    mutating func prepend(_ string: String) {
        self = "\(string)\(self)"
    }
}
