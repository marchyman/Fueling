//
//  FuelingState.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/16/24.
//

import Foundation
import OSLog
import SwiftUI

extension Logger: @unchecked Sendable {}

@MainActor
@Observable
final class FuelingState {
    var vehicles: [Vehicle] = []
    private let fuelingDB: FuelingDB
    private var ps: PhoneSession!

    init(forPreview: Bool = false) {
        fuelingDB = try! FuelingDB(inMemory: forPreview)
        ps = PhoneSession(state: self)
        do {
            try getVehicles()
            sendAppContext()
        } catch {
            Self.log.error("get vehicles: \(error.localizedDescription, privacy: .public)")
        }
    }
}

extension FuelingState {
    // logging
    nonisolated static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                        category: "FuelingState")
}

extension FuelingState {
    // populate the vehicles array from database contents
    private func getVehicles() throws {
        vehicles = try fuelingDB.read(sortBy: SortDescriptor<Vehicle>(\.name))
    }

    // build and return a plist of current stats for a vehicle
    func getStats(for vehicle: Vehicle) -> [String: Any] {
        var plist: [String: Any] = [:]
        plist[MessageKey.cost] = vehicle.fuelCost
        plist[MessageKey.gallons] = vehicle.fuelUsed
        plist[MessageKey.miles] = vehicle.milesDriven
        return plist
    }

    // send the current app state (vehicle name and stats) to the watch
    // as an application context message
    func sendAppContext() {
        guard ps.session.activationState == .activated else {
            Self.log.debug("\(#function) session not activated")
            return
        }
        guard ps.session.isWatchAppInstalled else {
            Self.log.debug("\(#function) companion app not installed")
            return
        }
        guard ps.session.isReachable else {
            Self.log.debug("\(#function) session not reachable")
            return
        }
        var context: [String: Any] = [:]
        for vehicle in vehicles {
            context[vehicle.name] = getStats(for: vehicle)
        }
        Self.log.debug("\(#function) \(context, privacy: .public)")
        do {
            try ps.session.updateApplicationContext(context)
        } catch {
            Self.log.error("\(#function) \(error.localizedDescription, privacy: .public)")
        }
    }

    // create a fueling entry and add it to the named vehicle
    @discardableResult
    func addFuel(name: String, cost: Double, gallons: Double, odometer: Int) -> String {
        if let vehicle = vehicles.first(where: { $0.name == name }) {
            let fuel = Fuel(odometer: odometer, amount: gallons, cost: cost)
            vehicle.fuelings.append(fuel)
            do {
                try fuelingDB.update(vehicle: vehicle)
                sendAppContext()
                return MessageKey.updated
            } catch {
                Self.log.error("#function: \(error.localizedDescription, privacy: .public)")
                return error.localizedDescription
            }
        }
        return "Cannot find vehicle named \(name)"
    }
}

// create/update/delete operation on fuelingDB
extension FuelingState {

    func create(vehicle: Vehicle) {
        do {
            try fuelingDB.create(vehicle: vehicle)
            try getVehicles()
        } catch {
            Self.log.error("#function: \(error.localizedDescription, privacy: .public)")
        }

    }

    func update(vehicle: Vehicle) {
        do {
            try fuelingDB.update(vehicle: vehicle)
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
