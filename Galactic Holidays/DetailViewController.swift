//
//  DetailViewController.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 14/10/2020.
//

import UIKit

class DetailViewController: UIViewController {

    var destination: Destination?

    @IBOutlet private weak var heading: UILabel!
    @IBOutlet private weak var subHeading: UILabel!
    @IBOutlet private weak var heroImage: UIImageView!
    @IBOutlet private weak var distance: UILabel!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var detail: UILabel!
    @IBOutlet private weak var likeImage: UIImageView!
    @IBOutlet private weak var promoView: UIView!

    private var liked = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)

        guard let destination = destination else { return }

        heading.text = destination.name
        subHeading.text = destination.subtitle
        heroImage.image = UIImage(named: "\(destination.name)-hero")

        distance.text = "\(destination.distance)M km"
        rating.text = formattedRating()

        detail.text = destination.description

        promoView.layer.cornerRadius = 50
        promoView.isHidden = !destination.promo

        setupLike()
        growPromo()
    }

    private func setupLike() {
        setLikeImage()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLike))
        likeImage.addGestureRecognizer(tapGesture)
    }

    private func setLikeImage() {
        let heartImage = UIImage(systemName: liked ? "heart.fill" : "heart")
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
        liked.toggle()
        setLikeImage()
    }

    private func formattedRating() -> String {
        guard let rating = destination?.rating else { return "☆ ☆ ☆ ☆ ☆" }

        var formatted = ""
        for _ in 0..<rating {
            formatted.append("⭐️ ")
        }

        let padding = 5 - rating
        for _ in 0..<padding {
            formatted.append("☆ ")
        }

        return formatted
    }
}
