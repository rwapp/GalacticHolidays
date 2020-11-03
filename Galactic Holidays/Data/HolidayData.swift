//
//  HolidayData.swift
//  Galactic Holidays
//
//  Created by Rob Whitaker on 14/10/2020.
//

import Foundation

// swiftlint:disable line_length

class HolidayData {

    private let mars = Destination(name: "Mars",
                                   subtitle: "The red planet",
                                   price: 100,
                                   description: "Big red thing",
                                   promo: true,
                                   distance: 55,
                                   temp: -125,
                                   rating: 4)

    private let saturn = Destination(name: "Saturn",
                                     subtitle: "It's got rings",
                                     price: 1000,
                                     description: "Saturn is an oblate spheroid. It's equatorial and polar radii differ by almost 10%: 60,268 km versus 54,364 km. Saturn has an intrinsic magnetic field that has a simple, symmetric shape – a magnetic dipole. Its strength at the equator – 20 µT. The average distance between Saturn and the Sun is over 9 AU.",
                                     distance: 1200,
                                     temp: -178,
                                     rating: 3)

    lazy var holidays = [mars, saturn]
}
