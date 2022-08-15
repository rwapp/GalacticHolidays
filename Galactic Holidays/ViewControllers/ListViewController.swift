//
//  ListViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 14/10/2020.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet private weak var holidaysTable: UITableView!
    @IBOutlet private weak var carousel: UICollectionView!

    private var timer: Timer?
    private var counter: Int = 0

    private var data = HolidayData()

    override func viewDidLoad() {
        super.viewDidLoad()

        holidaysTable.dataSource = self
        holidaysTable.delegate = self
        holidaysTable.register(UINib(nibName: "PlanetTableViewCell", bundle: nil), forCellReuseIdentifier: "planetCell")
        holidaysTable.tableFooterView = UIView()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "brand")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()

        setupCarousel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        holidaysTable.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let destinationVC = segue.destination as? DetailViewController,
           let destination = sender as? Int {
            destinationVC.selection = destination
            destinationVC.data = data
        }
    }

    private func setupCarousel() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width,
                                 height: carousel.frame.height)

        carousel.collectionViewLayout = layout

        carousel.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil),
                          forCellWithReuseIdentifier: "heroImage")

        carousel.dataSource = self

        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.counter >= self.data.holidays.count {
                self.counter = 0
            }

            self.carousel.scrollToItem(at: IndexPath(item: self.counter,
                                                     section: 0),
                                       at: .centeredHorizontally,
                                       animated: true)
            self.counter += 1
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.holidays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "planetCell")
        let item = data.holidays[indexPath.row]

        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.subtitle
        cell.accessibilityLabel = "Holiday"

        let image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)

        let imageView = UIImageView(image: image)

        if item.favourite {
            imageView.tintColor = .orange
        } else {
            imageView.tintColor = .black
        }

        cell.accessoryView = imageView

        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath.row)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.holidays.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heroImage", for: indexPath)

        if let cell = cell as? ImageCollectionViewCell {

            let destination = data.holidays[indexPath.item]
            let image = UIImage(named: "\(destination.name)-hero")

            cell.image = image
            cell.imageDescription = destination.imageDescription
        }
        return cell
    }
}
