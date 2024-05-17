//
//  FuelingDB.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/16/24.
//

import Foundation
import SwiftData

final class FuelingDB {
    let container: ModelContainer

    init(inMemory: Bool = false) throws {
        let configuration = ModelConfiguration(for: Vehicle.self,
                                               isStoredInMemoryOnly: inMemory)
        container = try ModelContainer(for: Vehicle.self,
                                       configurations: configuration)
        if inMemory {
            addTestVehicles()
            addTestFuelings()
        }
    }
}

// Add test data for previews
extension FuelingDB {
    func addTestVehicles() {
        let vehicles: [Vehicle] = [
            Vehicle(name: "Honda Accord", odometer: 12345),
            Vehicle(name: "KTM790", odometer: 20323)
        ]

        try! create(vehicles: vehicles)
    }

    func addTestFuelings() {
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<Vehicle>(
            predicate: #Predicate { $0.name == "Honda Accord" }
        )
        let vehicle = try! context.fetch(fetchDescriptor)[0]
        vehicle.fuelings.append(Fuel(odometer: 12555,
                                     amount: 4.14, cost: 22.13))
        vehicle.fuelings.append(Fuel(odometer: 12666,
                                     amount: 2.03, cost: 10.17))
        try! context.save()
    }
}

// DB CRUD functions
extension FuelingDB {

    func create(vehicles: [Vehicle]) throws {
        let context = ModelContext(container)
        for vehicle in vehicles {
            context.insert(vehicle)
        }
        try context.save()
    }

    func create(vehicle: Vehicle) throws {
        let context = ModelContext(container)
        context.insert(vehicle)
        try context.save()
    }

    func read(sortBy sortDescriptors: SortDescriptor<Vehicle>...) throws -> [Vehicle] {
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<Vehicle>(
            sortBy: sortDescriptors
        )
        return try context.fetch(fetchDescriptor)
    }

    func update(vehicle: Vehicle) throws {
        let context = ModelContext(container)
        context.insert(vehicle)
        try context.save()
    }

    func delete(vehicle: Vehicle) throws {
        let context = ModelContext(container)
        let idToDelete = vehicle.persistentModelID
        try context.delete(model: Vehicle.self, where: #Predicate { vehicle in
            vehicle.persistentModelID == idToDelete
        })
        try context.save()
    }
}
