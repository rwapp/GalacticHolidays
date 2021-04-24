//
//  ViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 14/10/2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var holidaysTable: UITableView!

    private let data = HolidayData().holidays

    override func viewDidLoad() {
        super.viewDidLoad()

        holidaysTable.dataSource = self
        holidaysTable.delegate = self

        holidaysTable.tableFooterView = UIView()

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let destinationVC = segue.destination as? DetailViewController,
           let destination = sender as? Destination {
            destinationVC.destination = destination
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: "HolidayCell")

        let item = data[indexPath.row]

        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.subtitle
        cell.accessibilityLabel = "Holiday"

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: data[indexPath.row])
    }
}
