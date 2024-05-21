//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
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
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: timestamp)
    }

    // given a fuel instance return the number of miles since the previous
    // entry.
    func miles() -> Int {
        if let vehicle {
            // reverse sorted.  The next index is the prior entry.
            let vehicleFuelings = vehicle.fuelingsByTimestamp()
            if let index = vehicleFuelings.firstIndex(of: self) {
                if index == vehicleFuelings.count - 1 {
                    return odometer - vehicle.odometer
                }
                let priorEntry = vehicleFuelings[index + 1]
                return odometer - priorEntry.odometer
            } else {
                fatalError("Fueling entry not found")
            }
        }
        return 0
    }
}
