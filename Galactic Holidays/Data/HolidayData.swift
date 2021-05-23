//
//  HolidayData.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 14/10/2020.
//

import Foundation

// swiftlint:disable line_length

class HolidayData {

    private let mercury = Destination(name: "Mercury",
                                      subtitle: "The planet, not the element.",
                                      price: 1000,
                                      description: "At just 46 million km from the sun, Mercury is the perfect destination for anyone looking to top up their tan.",
                                      distance: 28,
                                      temp: 462,
                                      rating: 1,
                                      imageDescription: "Mercury in vibrant colour")

    private let venus = Destination(name: "Venus",
                                    subtitle: "Your fire, your desire.",
                                    price: 1000,
                                    description: "Venus is one of the brightest objects visible in the night sky from earth, here's your opportunity to see your neighbours looking back at you in envy.",
                                    distance: 67,
                                    temp: 464,
                                    rating: 4,
                                    imageDescription: "The planet Venus in profile")

    private let mars = Destination(name: "Mars",
                                   subtitle: "The red planet.",
                                   price: 1000,
                                   description: "Big red thing",
                                   distance: 55,
                                   temp: -125,
                                   rating: 5,
                                   imageDescription: "The surface of Mars.")

    private let jupiter = Destination(name: "Jupiter",
                                      subtitle: "Bringer of joy.",
                                      price: 1000,
                                      description: "At 11 times the size of the Earth there's an area of Jupiter to suit everyone.",
                                      promo: true,
                                      distance: 470,
                                      temp: -108,
                                      rating: 2,
                                      imageDescription: "A profile of Jupiter and one of its moons")

    private let saturn = Destination(name: "Saturn",
                                     subtitle: "We liked it so we put a ring on it.",
                                     price: 1000,
                                     description: "Saturn is an oblate spheroid. It's equatorial and polar radii differ by almost 10%: 60,268 km versus 54,364 km. Saturn has an intrinsic magnetic field that has a simple, symmetric shape – a magnetic dipole. Its strength at the equator – 20 µT. The average distance between Saturn and the Sun is over 9 AU.",
                                     distance: 1200,
                                     temp: -178,
                                     rating: 3,
                                     imageDescription: "A quarter silhouette of Saturn.")

    private let uranus = Destination(name: "Uranus",
                                     subtitle: "No cheap jokes here, this app is cleaner than Uranus.",
                                     price: 1000,
                                     description: "The closest of the ice giants, Uranus is the ideal destination for winter sports lovers.",
                                     promo: true,
                                     distance: 1929,
                                     temp: -197,
                                     rating: 4,
                                     imageDescription: "A perfectly round Uranus")

    private let neptune = Destination(name: "Neptune",
                                      subtitle: "The ultimate road trip.",
                                      price: 1000,
                                      description: "Wear all the kool kids go to spend they're vacatoin time.",
                                      distance: 2782,
                                      temp: -201,
                                      rating: 5,
                                      imageDescription: "Neptune in brilliant glassy blue")

    lazy var holidays = [mercury, venus, mars, jupiter, saturn, uranus, neptune]
}
