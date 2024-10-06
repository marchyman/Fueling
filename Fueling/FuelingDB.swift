//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
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

    // update a vehicle by appending a fueling entry
    func update(name: String, fuel: Fuel) throws {
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<Vehicle>(
            predicate: #Predicate { $0.name == name }
        )
        let vehicle = try context.fetch(fetchDescriptor)[0]
        vehicle.fuelings.append(fuel)
        try context.save()
    }

    // update a fueling entry
    func update(fuel: Fuel) throws {
        let context = ModelContext(container)
        let key = fuel.timestamp
        let fetchDescriptor = FetchDescriptor<Fuel>(
            predicate: #Predicate { $0.timestamp == key }
        )
        let fueling = try context.fetch(fetchDescriptor)[0]
        fueling.odometer = fuel.odometer
        fueling.amount = fuel.amount
        fueling.cost = fuel.cost
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
