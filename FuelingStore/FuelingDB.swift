//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import Foundation
import SwiftData

final class FuelingDB {
    let container: ModelContainer
    let context: ModelContext

    init(inMemory: Bool = false) throws {
        let configuration = ModelConfiguration(
            for: Vehicle.self,
            isStoredInMemoryOnly: inMemory)
        container = try ModelContainer(
            for: Vehicle.self,
            configurations: configuration)
        context = ModelContext(container)
        if inMemory {
            if CommandLine.arguments.contains("-UITEST") {
                addOneVehicle()
            } else {
                addTestVehicles()
                addTestFuelings()
            }
        } else {
            // Check if the DB needs to be emptied for testing
            if CommandLine.arguments.contains("-EMPTY") {
                let fetchDescriptor = FetchDescriptor<Vehicle>()
                let vehicles = (try? context.fetch(fetchDescriptor)) ?? []
                for vehicle in vehicles {
                    try? delete(vehicle: vehicle)
                }
            }
        }
    }
}

// Add test data for previews
extension FuelingDB {
    func addOneVehicle() {
        let vehicle = Vehicle(name: "Test Vehicle", odometer: 7)
        try! create(vehicle: vehicle)
    }

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
        vehicle.fuelings.append(
            Fuel(odometer: 12555, amount: 4.14, cost: 22.13))
        vehicle.fuelings.append(
            Fuel(odometer: 12666, amount: 2.03, cost: 10.17))
        try! context.save()
    }
}

// DB CRUD functions
extension FuelingDB {

    enum FuelingDBError: Error {
        case vehicleNotFound
        case fuelNotFound
    }
    func create(vehicles: [Vehicle]) throws {
        for vehicle in vehicles {
            context.insert(vehicle)
        }
        try context.save()
    }

    func create(vehicle: Vehicle) throws {
        context.insert(vehicle)
        try context.save()
    }

    func read(sortBy sortDescriptors: SortDescriptor<Vehicle>...) throws -> [Vehicle] {
        let fetchDescriptor = FetchDescriptor<Vehicle>(
            sortBy: sortDescriptors
        )
        return try context.fetch(fetchDescriptor)
    }

    // update a vehicle by appending a fueling entry
    func update(name: String, fuel: Fuel) throws {
        let fetchDescriptor = FetchDescriptor<Vehicle>(
            predicate: #Predicate { $0.name == name }
        )
        if let vehicle = try context.fetch(fetchDescriptor).first {
            vehicle.fuelings.append(fuel)
            try context.save()
        } else {
            throw FuelingDBError.vehicleNotFound
        }
    }

    // update a fueling entry
    func update(key: Date, fuelData: FuelData) throws {
        let fetchDescriptor = FetchDescriptor<Fuel>(
            predicate: #Predicate { $0.timestamp == key }
        )
        if let fueling = try context.fetch(fetchDescriptor).first {
            fueling.odometer = fuelData.odometer
            fueling.amount = fuelData.amount
            fueling.cost = fuelData.cost
            try context.save()
        } else {
            throw FuelingDBError.fuelNotFound
        }
    }

    func delete(vehicle: Vehicle) throws {
        let idToDelete = vehicle.persistentModelID
        try context.delete(
            model: Vehicle.self,
            where: #Predicate { vehicle in
                vehicle.persistentModelID == idToDelete
            })
        try context.save()
    }
}
