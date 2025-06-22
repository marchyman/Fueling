//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import OSLog
import SwiftUI
import UDF

// Actions that cause state changes

enum FuelingAction: Equatable {
    case addVehicleButtonTapped(String, Int)
    case addFuelButtonTapped(String, FuelData)
    case addFuelReceived(String, FuelData)
    case onDeleteRequested(name: String)
    case phoneSessionActivated(PhoneSession)
}

// Reducer function to process actions, returning a new state

struct FuelingReducer: Reducer {
    func reduce(_ state: FuelingState,
                _ action: FuelingAction) -> FuelingState {
        var newState = state

        switch action {
        case .addVehicleButtonTapped(let name, let odometer):
            let newVehicle = Vehicle(name: name, odometer: odometer)
            newState.create(vehicle: newVehicle)
            newState.refreshVehicles()
        case .addFuelButtonTapped(let name, let fuelData):
            newState.addFuel(name: name, fuelData: fuelData)
            newState.refreshVehicles()
        case .addFuelReceived(let name, let sendableFuel):
            newState.addFuel(name: name, fuelData: sendableFuel)
            newState.refreshVehicles()
        case .onDeleteRequested(let name):
            if let vehicle = newState.vehicles.first(where: { $0.name == name }) {
                newState.delete(vehicle: vehicle)
                newState.refreshVehicles()
            } else {
                newState.errorMessage = "Could not find vehicle '\(name)'"
            }
        case .phoneSessionActivated(let ps):
            newState.phoneSession = ps
        }

        return newState
    }
}
