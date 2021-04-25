//
//  SuccessViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 23/04/2021.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "space")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .white
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
