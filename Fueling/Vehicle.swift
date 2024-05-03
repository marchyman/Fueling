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
    @Relationship(deleteRule: .cascade, inverse: \Fuel.vehicle)
    var fuelings: [Fuel]!

    init(name: String, odometer: Int, timestamp: Date = Date.now) {
        self.name = name
        initialTimestamp = timestamp
        self.odometer = odometer
        self.fuelings = []
    }
}

extension Vehicle {
    
    // return array of fuelings sorted such that the most recent
    // fueling is the first entry in the array.

    func fuelingsByTimestamp() -> [Fuel] {
        let descriptors: [SortDescriptor<Fuel>] = [
            .init(\.timestamp, order: .reverse)
        ]
        return fuelings.sorted(using: descriptors)
    }

    // calculate the total fuel used
    var fuelUsed: Double {
        fuelings.reduce(0.0) { $0 + $1.amount }
    }

    // return the miles driven since added
    var milesDriven: Int {
        if let lastOdometerReading = fuelingsByTimestamp().first?.odometer {
            return lastOdometerReading - odometer
        }
        return 0
    }

    // return miles/gallon
    var mpg: Double {
        let numberOfGallons = fuelUsed
        if numberOfGallons != 0 {
            return Double(milesDriven) / numberOfGallons
        }
        return 0
    }

    // return total fuel cost as a formatted string
    var fuelCost: Double {
        fuelings.reduce(0.0) { $0 + $1.cost}
    }

    // return cost per gallon of fuel as a formatted string
    var costPerGallon: Double {
        let gallons = fuelUsed
        if gallons != 0 {
            return fuelCost / gallons
        }
        return 0
    }

    // return cost per mile as a formatted string
    var costPerMile: Double {
        let miles = Double(milesDriven)
        if miles != 0 {
            return fuelCost / miles
        }
        return 0
    }
}

extension Vehicle {
    func allVehicles() {

    }
}
