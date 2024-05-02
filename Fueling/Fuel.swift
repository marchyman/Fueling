//
//  Fuel.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/7/23.
//

import Foundation
import SwiftData

// Because vehicle is the inverse relation of fuelings it can't be
// initialized. If it is the app will crash on an attempt to create
// an instance.
//
// Use it this way -- given an existing instance of vehicle
//      vehicle.fuelings.append(Fuel(odometer: odometer, amount: gallons,
//                                   cost: cost))
// will update fuelings in the vehicle and vehicle in fuelings.

@Model
final class Fuel {
    @Attribute(.unique)
    var timestamp: Date
    var vehicle: Vehicle?
    var odometer: Int
    var amount: Double
    var cost: Double

    init(odometer: Int,
         amount: Double,
         cost: Double,
         timestamp: Date = Date.now) {
        self.odometer = odometer
        self.amount = amount
        self.cost = cost
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

    // given a fuel instance calculate various values
    func fuelStats() -> (Int, Double, Double){
        if let vehicle {
            // reverse sorted.  The next index is the prior entry.
            let vehicleFuelings = vehicle.fuelingsByTimestamp()
            if let index = vehicleFuelings.firstIndex(of: self) {
                let priorEntry: Fuel
                if index == vehicleFuelings.count - 1 {
                    // fake a prior entry from the vehicle
                    priorEntry = Fuel(odometer: vehicle.odometer, amount: 0, cost: 0)
                } else {
                    priorEntry = vehicleFuelings[index + 1]
                }
                let miles = odometer - priorEntry.odometer
                let gallons = amount - priorEntry.amount
                let cost = self.cost - priorEntry.cost
                return (miles, gallons, cost)
            } else {
                fatalError("Fueling entry not found")
            }
        }
        return (0, 0, 0)
    }
}
