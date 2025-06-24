//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import SwiftData
import Testing
import UDF

@testable import Fueling

@MainActor
struct VehicleTests {

    // forPreview uses an in memory database
    func createStore() -> Store<FuelingState, FuelingAction> {
        return Store(initialState: FuelingState(forPreview: true),
                     reduce: FuelingReducer(),
                     name: "Test Fueling Store")
    }

    @Test func vehicleWithFuelTests() async throws {
        let store = createStore()
        let vehicle = try #require(store.vehicles.first)
        #expect(vehicle.name == "Honda Accord")

        let fuelings = vehicle.fuelingsByTimestamp()
        #expect(fuelings.count == 2)
        #expect(vehicle.fuelUsed == 6.17)
        #expect(vehicle.milesDriven == 321)
        #expect(vehicle.mpg.rounded() == 52)
        #expect(vehicle.fuelCost == 32.30)
        #expect(Int(vehicle.costPerGallon * 100) == 523)
        #expect(Int(vehicle.costPerMile * 100) == 10)
    }

    @Test func vehicleWithoutFuelTests() async throws {
        let store = createStore()
        let vehicle = try #require(store.vehicles.last)
        #expect(vehicle.name == "KTM790")

        let fuelings = vehicle.fuelingsByTimestamp()
        #expect(fuelings.count == 0)
        #expect(vehicle.fuelUsed == 0)
        #expect(vehicle.milesDriven == 0)
        #expect(vehicle.mpg.rounded() == 0.0)
        #expect(vehicle.fuelCost == 0.0)
        #expect(Int(vehicle.costPerGallon * 100) == 0)
        #expect(Int(vehicle.costPerMile * 100) == 0)
    }

}
