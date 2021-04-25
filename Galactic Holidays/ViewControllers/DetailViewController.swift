//
//  DetailViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 14/10/2020.
//

import UIKit

class DetailViewController: UIViewController {

    var selection: Int?
    var data: HolidayData?

    @IBOutlet private weak var heading: UILabel!
    @IBOutlet private weak var subHeading: UILabel!
    @IBOutlet private weak var heroImage: UIImageView!
    @IBOutlet private weak var distance: UILabel!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var detail: UILabel!
    @IBOutlet private weak var likeImage: UIImageView!
    @IBOutlet private weak var promoView: UIView!
    @IBOutlet private weak var popularView: UIView!
    @IBOutlet private weak var popularIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let destination = data?.holidays[selection ?? 0] else { return }

        heading.text = destination.name
        subHeading.text = destination.subtitle
        heroImage.image = UIImage(named: "\(destination.name)-hero")

        distance.text = "\(destination.distance)M km"
        rating.attributedText = formattedRating()

        detail.text = destination.description

        promoView.layer.cornerRadius = 50
        promoView.isHidden = !destination.promo

        setupLike()
        growPromo()
        setupPopular()
    }

    private func setupLike() {
        setLikeImage()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLike))
        likeImage.addGestureRecognizer(tapGesture)
    }

    private func setupPopular() {
        guard let destination = data?.holidays[selection ?? 0] else { return }
        popularView.isHidden = destination.rating < 5
        popularIcon.image = UIImage(systemName: "exclamationmark.triangle")
        popularIcon.isAccessibilityElement = true
        popularIcon.accessibilityLabel = "Warning triangle"
    }

    private func setLikeImage() {
        guard let destination = data?.holidays[selection ?? 0] else { return }
        let heartImage = UIImage(systemName: destination.favourite ? "star.fill" : "star")
        likeImage.image = heartImage
    }

    private func growPromo() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.promoView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { [weak self] _ in
            UIView.animate(withDuration: 1, animations: {
                self?.shrinkPromo()
            })
        }
    }

    private func shrinkPromo() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.promoView.transform = CGAffineTransform.identity
        }) { [weak self] _ in
            UIView.animate(withDuration: 1, animations: {
                self?.growPromo()
            })
        }
    }

    @objc
    func toggleLike() {
        data?.holidays[selection ?? 0].favourite.toggle()
        setLikeImage()
    }

    private func formattedRating() -> NSAttributedString {

        let star = NSTextAttachment()
        star.image = UIImage(systemName: "star")?
            .withTintColor(.orange)
        let starString = NSAttributedString(attachment: star)

        let starFill = NSTextAttachment()
        starFill.image = UIImage(systemName: "star.fill")?
            .withTintColor(.orange)
        let starFillString = NSAttributedString(attachment: starFill)

        guard let destination = data?.holidays[selection ?? 0] else { return NSAttributedString() }

        let formatted = NSMutableAttributedString()
        for _ in 0..<destination.rating {
            formatted.append(starFillString)
        }

        let padding = 5 - destination.rating
        for _ in 0..<padding {
            formatted.append(starString)
        }

        return formatted
    }
}
