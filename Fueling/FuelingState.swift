//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import Foundation
import OSLog
import SwiftUI

@MainActor
@Observable
final class FuelingState {
    private(set) var vehicles: [Vehicle] = []
    private let fuelingDB: FuelingDB
    private var ps: PhoneSession!

    init(forPreview: Bool = false) {
        fuelingDB = try! FuelingDB(inMemory: forPreview)
        ps = PhoneSession(state: self)
        do {
            try getVehicles()
            sendInitialAppContext()
        } catch {
            Self.log.error("get vehicles: \(error.localizedDescription, privacy: .public)")
        }
    }
}

extension FuelingState {
    // logging
    static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                            category: "FuelingState")
}

extension FuelingState {

    // populate the vehicles array from database contents.  Private to
    // this class as all outside access to vehicles should be through
    // the class vehicle array.
    private func getVehicles() throws {
        vehicles = try fuelingDB.read(sortBy: SortDescriptor<Vehicle>(\.name))
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

    // send the current app state (vehicle name and stats) to the watch
    // as an application context message.  Lots of checks here as this
    // is the first communications sent by the phone and I'd like to
    // see the debug messages if things fail when testing.
    @discardableResult
    func sendAppContext() -> Bool {
        guard ps.session.activationState == .activated else {
            Self.log.debug("\(#function) session not activated")
            return false
        }
        guard ps.session.isWatchAppInstalled else {
            Self.log.debug("\(#function) companion app not installed")
            return false
        }
        guard ps.session.isReachable else {
            Self.log.debug("\(#function) session not reachable")
            return false
        }
        var context: [String: Any] = [:]
        for vehicle in vehicles {
            context[vehicle.name] = getStats(for: vehicle)
        }
        Self.log.debug("\(#function) \(context, privacy: .public)")
        do {
            try ps.session.updateApplicationContext(context)
            return true
        } catch {
            Self.log.error("\(#function) \(error.localizedDescription, privacy: .public)")
        }
        return false
    }

    // Wait a second for the phone session to be activated and the watch
    // to become reachable before sending the initial app context message.
    // retry every second until the message is sent. Cap the number of
    // retries -- the watch app may not be installed.
    func sendInitialAppContext() {
        Task(priority: .background) {
            for _ in 0...9 {
                try? await Task.sleep(for: .seconds(1))
                if sendAppContext() {
                    break
                }
            }
        }
    }

    // create a fueling entry and add it to the named vehicle.
    func addFuel(name: String, cost: Double, gallons: Double, odometer: Int) {
        if let vehicle = vehicles.first(where: { $0.name == name }) {
            let fuel = Fuel(odometer: odometer, amount: gallons, cost: cost)
            // update the database with the new fuel entry
            do {
                try fuelingDB.update(name: vehicle.name, fuel: fuel)
                try getVehicles()
                sendAppContext()
            } catch {
                Self.log.error("\(#function): \(error.localizedDescription, privacy: .public)")
            }
        } else {
            Self.log.error("\(#function): Cannot find vehicle named \(name)")
        }
    }
}

// create/update/delete operation on fuelingDB
// reads are handled by getVehicles, above.
extension FuelingState {

    func create(vehicle: Vehicle) {
        do {
            try fuelingDB.create(vehicle: vehicle)
            try getVehicles()
        } catch {
            Self.log.error("#function: \(error.localizedDescription, privacy: .public)")
        }

    }

    func update(fuel: Fuel) {
        do {
            try fuelingDB.update(fuel: fuel)
            try getVehicles()
        } catch {
            Self.log.error("#function: \(error.localizedDescription, privacy: .public)")
        }
    }

    func delete(vehicle: Vehicle) {
        do {
            try fuelingDB.delete(vehicle: vehicle)
            try getVehicles()
        } catch {
            Self.log.error("#function: \(error.localizedDescription, privacy: .public)")
        }

    }
}
