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
    var fuelings: [Fuel]?

    init(name: String, odometer: Int, timestamp: Date = Date.now) {
        self.name = name
        initialTimestamp = timestamp
        self.odometer = odometer
    }
}

extension Vehicle {
    static func sample() -> Vehicle {
        let vehicle = Vehicle(name: "Test car", odometer: 12345)
        vehicle.fuelings?.append(Fuel(vehicle, odometer: 12555,
                                      amount: 4.14, cost: 22.13))
        vehicle.fuelings?.append(Fuel(vehicle, odometer: 12666,
                                      amount: 2.03, cost: 10.17))
        return vehicle
    }
}
