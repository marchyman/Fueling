//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import OSLog
import SwiftData
import SwiftUI
import WatchConnectivity

struct FuelingState {
    private(set) var vehicles: [Vehicle] = []
    private let fuelingDB: FuelingDB
    var phoneSession: PhoneSession?
    var errorMessage: String?

    init(forPreview: Bool = false) {
        fuelingDB = try! FuelingDB(inMemory: forPreview)
        refreshVehicles()
    }
}

extension FuelingState {

    // return the context shared with the watch component
    func appContext() -> [String: Any] {
        var context: [String: Any] = [:]
        for vehicle in vehicles {
            context[vehicle.name] = getStats(for: vehicle)
        }
        return context
    }

    // populate the vehicles array from database contents.  Private to
    // this class as all outside access to vehicles should be through
    // the class vehicle array.  Send the current app context to the
    // watch if a session has been created.
    mutating func refreshVehicles() {
        do {
            vehicles = try fuelingDB.read(sortBy: SortDescriptor<Vehicle>(\.name))
            if let phoneSession {
                Task { @MainActor in
                    phoneSession.sendAppContext()
                }
            }
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

    // create a fueling entry and add it to the named vehicle.
    mutating func addFuel(name: String, fuelData: FuelData) {
        if let vehicle = vehicles.first(where: { $0.name == name }) {
            let fuel = Fuel(from: fuelData)
            do {
                try fuelingDB.update(name: vehicle.name, fuel: fuel)
            } catch {
                errorMessage = error.localizedDescription
                Logger(subsystem: "org.snafu", category: "FuelingState")
                    .error("\(#function): \(error.localizedDescription, privacy: .public)")
            }
        } else {
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("\(#function): Cannot find vehicle named \(name)")
        }
    }
}

// create/update/delete operation on fuelingDB
// reads are handled by getVehicles, above.
extension FuelingState {

    mutating func create(vehicle: Vehicle) {
        do {
            try fuelingDB.create(vehicle: vehicle)
            refreshVehicles()
        } catch {
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("#function: \(error.localizedDescription, privacy: .public)")
        }

    }

    mutating func update(fuel: Fuel) {
        do {
            try fuelingDB.update(fuel: fuel)
            refreshVehicles()
        } catch {
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("#function: \(error.localizedDescription, privacy: .public)")
        }
    }

    mutating func delete(vehicle: Vehicle) {
        do {
            try fuelingDB.delete(vehicle: vehicle)
            refreshVehicles()
        } catch {
            Logger(subsystem: "org.snafu", category: "FuelingState")
                .error("#function: \(error.localizedDescription, privacy: .public)")
        }
    }
}
