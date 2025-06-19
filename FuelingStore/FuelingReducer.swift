//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import OSLog
import SwiftUI
import UDF

enum FuelingAction: Equatable, Sendable {
    case addNewVehicle(Vehicle)
    case addFuel(Fuel)
    case deleteVehicle(Vehicle)
    
}

struct FuelingReducer: Reducer {
    func reduce(_ state: FuelingState,
                _ action: FuelingAction) -> FuelingState {
        var newState = state

        switch action {
        case addNewVehicle(let vehicle):
            break
        case addFuel(let fuel):
            break
        case deleteVehicle(let vehicle):
            break
        }

        return newState
    }
}
