//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import OSLog
import SwiftUI
import WatchConnectivity

@MainActor
struct FuelingState: Equatable, Sendable {
    private(set) var vehicles: [Vehicle] = []
    private let fuelingDB: FuelingDB
    var errorMessage: String?

    init(forPreview: Bool = false) {
        fuelingDB = try! FuelingDB(inMemory: forPreview)
        refreshVehicles()
    }
}

extension FuelingState {

    // return the context shared with the watch component of the app
    func appContext() -> [String: Any] {
        var context: [String: Any] = [:]
        for vehicle in vehicles {
            context[vehicle.name] = getStats(for: vehicle)
        }
        return context
    }

    // populate the vehicles array from database contents.  Private to
    // this class as all outside access to vehicles should be through
    // the class vehicle array.
    mutating func refreshVehicles() {
        do {
            vehicles = try fuelingDB.read(sortBy: SortDescriptor<Vehicle>(\.name))
        } catch {
            errorMessage = error.localizedDescription
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("refresh vehicles: \(error.localizedDescription, privacy: .public)")
        }
    }

    // build and return a plist of current stats for a vehicle
    private func getStats(for vehicle: Vehicle) -> [String: Any] {
        var plist: [String: Any] = [:]
        plist[MessageKey.cost] = vehicle.fuelCost
        plist[MessageKey.gallons] = vehicle.fuelUsed
        plist[MessageKey.miles] = vehicle.milesDriven
        plist[MessageKey.timestamp] = Date.now
        return plist
    }

    // type used to package data received from the watch or app before sending
    // to the reducer

    struct FuelData: Equatable, Sendable {
        let name: String
        let cost: Double
        let gallons: Double
        let odometer: Int
    }

    // create a fueling entry and add it to the named vehicle.
    mutating func addFuel(data: FuelData) {
        if let vehicle = vehicles.first(where: { $0.name == data.name }) {
            let fuel = Fuel(odometer: data.odometer,
                            amount: data.gallons,
                            cost: data.cost)
            do {
                try fuelingDB.update(name: vehicle.name, fuel: fuel)
            } catch {
                errorMessage = error.localizedDescription
                Logger(subsystem: "org.snafu", category: "FuelingState")
                    .error("\(#function): \(error.localizedDescription, privacy: .public)")
            }
        } else {
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("\(#function): Cannot find vehicle named \(data.name)")
        }
    }
}

// create/update/delete operation on fuelingDB
// reads are handled by getVehicles, above.
extension FuelingState {

    mutating func create(vehicle: Vehicle) {
        do {
            try fuelingDB.create(vehicle: vehicle)
//            try getVehicles()
        } catch {
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("#function: \(error.localizedDescription, privacy: .public)")
        }

    }

    mutating func update(fuel: Fuel) {
        do {
            try fuelingDB.update(fuel: fuel)
//            try getVehicles()
        } catch {
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("#function: \(error.localizedDescription, privacy: .public)")
        }
    }

    mutating func delete(vehicle: Vehicle) {
        do {
            try fuelingDB.delete(vehicle: vehicle)
//            try getVehicles()
        } catch {
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("#function: \(error.localizedDescription, privacy: .public)")
        }
    }
}
