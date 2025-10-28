//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import OSLog
import SwiftUI
import UDF

// Events that cause state changes

enum FuelingEvent: Equatable {
    case addVehicleButtonTapped(String, Int)
    case addFuelButtonTapped(String, FuelData)
    case addFuelReceived(String, FuelData)
    case onDeleteRequested(vehicle: Vehicle)
    case phoneSessionActivated(PhoneSession)
    case editFuelUpdateButtonTapped(Date, FuelData)
}

// Reducer function to process event, returning a new state

struct FuelingReducer: Reducer {
    func reduce(_ state: FuelingState,
                _ event: FuelingEvent) -> FuelingState {
        var newState = state

        switch event {
        case .addVehicleButtonTapped(let name, let odometer):
            let newVehicle = Vehicle(name: name, odometer: odometer)
            newState.errorMessage = create(state: newState,
                                           vehicle: newVehicle)

        case .addFuelButtonTapped(let name, let fuelData):
            newState.errorMessage = addFuel(state: newState,
                                            vehicleName: name,
                                            fuelData: fuelData)

        case .addFuelReceived(let name, let fuelData):
            newState.errorMessage = addFuel(state: newState,
                                            vehicleName: name,
                                            fuelData: fuelData)

        case .onDeleteRequested(let vehicle):
            newState.errorMessage = delete(state: newState,
                                           vehicle: vehicle)

        case .phoneSessionActivated(let ps):
            newState.phoneSession = ps

        case .editFuelUpdateButtonTapped(let key, let fuelData):
            newState.errorMessage = editFuel(state: newState,
                                             key: key,
                                             fuelData: fuelData)
        }

        if let msg = state.errorMessage {
            Logger(subsystem: "org.snafu", category: "FuelingReducer")
                .error("\(#function): \(msg, privacy: .public)")
        }

        newState.vehicles = newState.sortedVehicles()
        // share the new state with the watch app
        if let ps = newState.phoneSession {
            ps.sendAppContext()
        }
        return newState
    }
}

// database updates

extension FuelingReducer {
    func create(state: FuelingState, vehicle: Vehicle) -> String? {
        do {
            try state.fuelingDB.create(vehicle: vehicle)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    func addFuel(state: FuelingState,
                 vehicleName: String,
                 fuelData: FuelData) -> String? {
        if let vehicle = state.vehicles.first(where: { $0.name == vehicleName }) {
            let fuel = Fuel(from: fuelData)
            do {
                try state.fuelingDB.update(name: vehicle.name, fuel: fuel)
                return nil
            } catch {
                return error.localizedDescription
            }
        } else {
            return "Cannot find vehicle named \(vehicleName)"
        }
    }

    func editFuel(state: FuelingState,
                  key: Date,
                  fuelData: FuelData) -> String? {
        do {
            try state.fuelingDB.update(key: key, fuelData: fuelData)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    func delete(state: FuelingState, vehicle: Vehicle) -> String? {
        do {
            try state.fuelingDB.delete(vehicle: vehicle)
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}
