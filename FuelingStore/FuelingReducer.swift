//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import OSLog
import SwiftUI
import UDF

// Actions that cause state changes

enum FuelingAction: Equatable, Sendable {
    case addVehicleButtonTapped(Vehicle)
    case addFuelReceived(FuelingState.FuelData)
    case onDeleteRequested(Vehicle)
}

// Reducer function to process actions, returning a new state

@MainActor
struct FuelingReducer: Reducer {
    func reduce(_ state: FuelingState,
                _ action: FuelingAction) -> FuelingState {
        var newState = state

        switch action {
        case .addVehicleButtonTapped(let vehicle):
            newState.create(vehicle: vehicle)
            newState.refreshVehicles()
        case .addFuelReceived(let fuelData):
            newState.addFuel(data: fuelData)
            newState.refreshVehicles()
        case .onDeleteRequested(let vehicle):
            newState.delete(vehicle: vehicle)
            newState.refreshVehicles()
        }

        return newState
    }
}
