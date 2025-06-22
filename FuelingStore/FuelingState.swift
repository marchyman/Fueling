//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import OSLog
import SwiftData
import SwiftUI
import WatchConnectivity

struct FuelingState {
    var vehicles: [Vehicle] = []
    let fuelingDB: FuelingDB
    var phoneSession: PhoneSession?
    var errorMessage: String?

    init(forPreview: Bool = false) {
        fuelingDB = try! FuelingDB(inMemory: forPreview)
        vehicles = sortedVehicles()
    }
}

extension FuelingState {

    // Return an array of known vehicles sorted by name
    func sortedVehicles() -> [Vehicle] {
        do {
            return try fuelingDB.read(sortBy: SortDescriptor<Vehicle>(\.name))
        } catch {
            return []
        }
    }

    // return the context shared with the watch component
    func appContext() -> [String: Any] {
        var context: [String: Any] = [:]
        for vehicle in vehicles {
            context[vehicle.name] = getStats(for: vehicle)
        }
        return context
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
}
