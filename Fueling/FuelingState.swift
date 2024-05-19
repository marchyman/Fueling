//
//  FuelingState.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/16/24.
//

import Foundation
import OSLog

extension Logger: @unchecked Sendable {}

@Observable
final class FuelingState {
    var vehicles: [Vehicle] = []
    private let fuelingDB: FuelingDB

    init(forPreview: Bool = false) {
        fuelingDB = try! FuelingDB(inMemory: forPreview)
        do {
            try getVehicles()
        } catch {
            Self.log.error("get vehicles: \(error.localizedDescription, privacy: .public)")
        }
    }
}

extension FuelingState {
    static let log = Logger(subsystem: Bundle.main.bundleIdentifier!,
                            category: "FuelingState")

    private func getVehicles() throws {
        vehicles = try fuelingDB.read(sortBy: SortDescriptor<Vehicle>(\.name))
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

// add fueling entry to database
extension FuelingState {

    func addFuel(vehicle: Vehicle, fuel: Fuel) {
        vehicle.fuelings.append(fuel)
        do {
            try fuelingDB.update(vehicle: vehicle)
        } catch {
            Self.log.error("#function: \(error.localizedDescription, privacy: .public)")
        }
    }

}
