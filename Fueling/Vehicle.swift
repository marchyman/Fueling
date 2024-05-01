//
//  Vehicle.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/5/23.
//

import Foundation
import SwiftData

@Model
final class Vehicle {
    @Attribute(.unique)
    var name: String
    var initialTimestamp: Date
    var odometer: Int
    var fuelings: [Fuel]!

    init(name: String, odometer: Int, timestamp: Date = Date.now) {
        self.name = name
        initialTimestamp = timestamp
        self.odometer = odometer
        self.fuelings = []
    }
}
