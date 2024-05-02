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
    func fuelUsed() -> Double {
        return fuelings.reduce(0.0) { $0 + $1.amount }
    }

    // return the miles driven since added
    func milesDriven() -> Int {
        if let lastOdometerReading = fuelingsByTimestamp().first?.odometer {
            return lastOdometerReading - odometer
        }
        return 0
    }

    // return miles/gallon
    func mpg() -> Double {
        let milesDriven = milesDriven()
        let numberOfGallons = fuelUsed()
        if numberOfGallons != 0 {
            return Double(milesDriven) / numberOfGallons
        }
        return 0
    }

    // return total fuel cost as a formatted string
    func fuelCost() -> String {
        let cost = fuelings.reduce(0) { $0 + $1.cost}
        return "$\(cost / 100).\(cost % 100)"
    }

    // return cost per gallon of fuel as a formatted string
    func costPerGallon() -> String {
        let cost = fuelings.reduce(0) { $0 + $1.cost}
        let gallons = fuelUsed()
        if gallons != 0 {
            let cpg = cost / Int(gallons.rounded(.up))
            return "$\(cpg / 100).\(cpg % 100)"
        }
        return "unknown"
    }

    // return cost per mile as a formatted string
    func costPerMile() -> String {
        let cost = fuelings.reduce(0) { $0 + $1.cost}
        let miles = milesDriven()
        if miles != 0 {
            let cpm = cost / miles
            return "$\(cpm / 100).\(cpm % 100)"
        }
        return "unknown"
    }
}
