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
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var leftBGView: UIView!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var rightBGView: UIView!

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
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        title = NSLocalizedString("LIST_VIEW.TITLE",
                                  comment: "")

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

        leftBGView.backgroundColor = UIColor(white: 0, alpha: 0.75)
        rightBGView.backgroundColor = UIColor(white: 0, alpha: 0.75)

        let leftAttachment = NSTextAttachment()
        leftAttachment.image = UIImage(systemName: "chevron.left")?.withTintColor(.white)
        leftButton.setAttributedTitle(NSAttributedString(attachment: leftAttachment), for: .normal)
        leftButton.accessibilityLabel = NSLocalizedString("LIST_VIEW.SCROLL_LEFT",
                                                          comment: "")

        let rightAttachment = NSTextAttachment()
        rightAttachment.image = UIImage(systemName: "chevron.right")?.withTintColor(.white)
        rightButton.setAttributedTitle(NSAttributedString(attachment: rightAttachment), for: .normal)
        rightButton.accessibilityLabel = NSLocalizedString("LIST_VIEW.SCROLL_RIGHT",
                                                           comment: "")
    }

    @IBAction
    func scrollRight() {
        let currentIndexPath = carousel.indexPathForItem(at: carousel.contentOffset)
        guard let item = currentIndexPath?.item,
              item < data.holidays.count - 1 else { return }

        carousel.scrollToItem(at: IndexPath(item: item + 1,
                                            section: 0),
                              at: .centeredHorizontally,
                              animated: true)
    }

    @IBAction
    func scrollLeft() {
        let currentIndexPath = carousel.indexPathForItem(at: carousel.contentOffset)
        guard let item = currentIndexPath?.item,
              item > 0 else { return }

        carousel.scrollToItem(at: IndexPath(item: item - 1,
                                            section: 0),
                              at: .centeredHorizontally,
                              animated: true)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        holidaysTable.reloadData()
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
        cell.accessibilityTraits.insert(.button)
        cell.accessoryType = .disclosureIndicator

        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0

        let starAttachment = NSTextAttachment()

        if item.favourite {
            cell.accessibilityValue = NSLocalizedString("LIST_VIEW.FAVOURITE_DESTINATION",
                                                        comment: "")
            starAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.orange)

        } else {
            let tintColour = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
            cell.accessibilityValue = ""
            starAttachment.image = UIImage(systemName: "star")?.withTintColor(tintColour)
        }

        let detail = NSMutableAttributedString(attachment: starAttachment)
        detail.append(NSAttributedString(string: " " + item.subtitle))
        cell.detailTextLabel?.attributedText = detail
        cell.detailTextLabel?.accessibilityLabel = item.subtitle

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
