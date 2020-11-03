//
//  BookingViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 19/10/2020.
//

import UIKit

class BookingViewController: UIViewController {

    @IBOutlet weak private var submit: UIButton!

    private var alert: CustomModalAlert?

    private var formValid: Bool = false {
        didSet {
            submit.isEnabled = formValid
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        submit.isEnabled = false
        eachTextField(view) {
            $0.delegate = self
        }

        idleTimer()
    }

    private func idleTimer() {

        _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            self.showTimeout()
            self.clearTextFields()
        }
    }

    private func showTimeout() {
        let alert = CustomModalAlert(frame: view.frame)
        alert.delegate = self
        alert.center = view.center
        self.alert = alert
        view.addSubview(alert)
    }

    private func clearTextFields() {
        eachTextField(view) {
            $0.text = nil
        }
    }

    private func validateForm() {
        var formValid = true

        eachTextField(view) {
            if $0.text?.count ?? 0 == 0 {
                formValid = false
            }
        }

        self.formValid = formValid
    }

    private func eachTextField(_ subview: UIView, _ action: (TextField) -> Void) {
        for view in subview.subviews {
            eachTextField(view, action)
            if let textField = view as? TextField {
                action(textField)
            }
        }
    }

    private func timedOut() {
        navigationController?.popViewController(animated: true)
    }
}

extension BookingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateForm()
    }
}

extension BookingViewController: CustomModalAlertDelegate {
    func dismiss() {
        alert?.removeFromSuperview()
        idleTimer()
    }
}
