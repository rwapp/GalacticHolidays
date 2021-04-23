//
//  SuccessViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 23/04/2021.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func homePressed() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
}
