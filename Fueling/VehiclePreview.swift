//
//  VehiclePreview.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/1/24.
//

import Foundation
import SwiftData

extension Vehicle {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Vehicle.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true))

        let vehicles: [Vehicle] = [
            Vehicle(name: "Honda Accord", odometer: 12345),
            Vehicle(name: "KTM790", odometer: 20323)
        ]

        for vehicle in vehicles {
            container.mainContext.insert(vehicle)
        }

        let vehicle = vehicles[0]
        vehicle.fuelings.append(Fuel(vehicle, odometer: 12555,
                                     amount: 4.14, cost: 22.13))
        vehicle.fuelings.append(Fuel(vehicle, odometer: 12666,
                                     amount: 2.03, cost: 10.17))

        return container
    }
}
