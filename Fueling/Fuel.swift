//
//  Fuel.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/7/23.
//

import Foundation
import SwiftData

@Model
final class Fuel {
    @Attribute(.unique)
    var timestamp: Date
    var vehicle: Vehicle
    var odometer: Int
    var amount: Double
    var cost: Int

    init(_ vehicle: Vehicle,
         odometer: Int,
         amount: Double,
         cost: Double,
         timestamp: Date = Date.now) {
        self.vehicle = vehicle
        self.odometer = odometer
        self.amount = amount
        self.cost = Int(cost * 100)
        self.timestamp = timestamp
    }
}

extension Fuel {
    var dateTime: String {
        return timestamp.formatted(
            Date.FormatStyle()
                .month(.twoDigits)
                .day(.twoDigits)
                .hour(.defaultDigits(amPM: .abbreviated))
                .minute(.twoDigits)
        )
    }
}
