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
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var promoView: UIView!
    @IBOutlet private weak var titleBG: UIView!
    @IBOutlet private weak var ratingContainer: UIView!
    @IBOutlet private weak var distanceContainer: UIView!
    @IBOutlet private weak var headerContainer: UIView!
    @IBOutlet private weak var detailStack: UIStackView!
    @IBOutlet private weak var distanceTitle: UILabel!
    @IBOutlet private weak var messageStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let destination = data?.holidays[selection ?? 0] else { return }

        heading.text = destination.name
        subHeading.text = destination.subtitle
        heroImage.image = UIImage(named: "\(destination.name)-hero")

        distance.text = "\(destination.distance)M km"
        rating.attributedText = formattedRating()

        detail.text = destination.description

        setupPromo()

        titleBG.backgroundColor = UIColor(white: 0, alpha: 0.75)

        setupLike()
        setupPopular()
        setupContainers()
    }

    private func setupLike() {
        guard let destination = data?.holidays[selection ?? 0] else { return }
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(systemName: destination.favourite ? "star.fill" : "star")?.withTintColor(.orange)
        let title = "Favourite destination"
        let buttonTitle = NSMutableAttributedString(string: "\(title): ")
        buttonTitle.append(NSAttributedString(attachment: starAttachment))
        likeButton.setAttributedTitle(buttonTitle, for: .normal)
        likeButton.accessibilityLabel = title
        likeButton.accessibilityUserInputLabels = ["Favourite destination", "Favourite", "Like", "Star"]

        if destination.favourite {
            likeButton.accessibilityTraits.insert(.selected)
        } else {
            likeButton.accessibilityTraits.remove(.selected)
        }
    }

    private func setupPopular() {
        guard let destination = data?.holidays[selection ?? 0] else { return }
        if destination.rating == 5 {
            addMessage("Popular destination")
        }
    }

    private func setupPromo() {
        guard let destination = data?.holidays[selection ?? 0],
              destination.promo else { return }

        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            addMessage("Only 5 remaining")
        } else {
            promoView.layer.cornerRadius = 50
            promoView.isHidden = false
        }
    }

    private func addMessage(_ string: String) {
        let warningAttachment = NSTextAttachment()
        warningAttachment.image = UIImage(systemName: "exclamationmark.triangle")
        let message = NSMutableAttributedString(attachment: warningAttachment)
        message.append(NSAttributedString(string: " \(string)"))
        let label = UILabel()
        label.attributedText = message
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.accessibilityLabel = string

        messageStack.addArrangedSubview(label)
    }

    private func setupContainers() {
        guard let destination = data?.holidays[selection ?? 0] else { return }
        ratingContainer.isAccessibilityElement = true
        let stars = destination.rating > 1 ? "stars" : "star"
        ratingContainer.accessibilityLabel = "Customer rating \(destination.rating) \(stars)"
        distanceContainer.isAccessibilityElement = true
        distanceContainer.accessibilityLabel = "Average distance \(destination.distance) million kilometres"

        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            detailStack.axis = .vertical
            distance.textAlignment = .natural
            distanceTitle.textAlignment = .natural
        }

        headerContainer.isAccessibilityElement = true
        headerContainer.accessibilityTraits.insert(.header)
        headerContainer.accessibilityLabel = "\(destination.name). \(destination.subtitle)"
    }

    @IBAction
    func toggleLike() {
        data?.holidays[selection ?? 0].favourite.toggle()
        setupLike()
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
