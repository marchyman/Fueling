//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import Foundation
import SwiftData
import Testing
import UDF

@testable import Fueling

@MainActor
struct FuelTests {

    // forPreview uses an in memory database
    func createStore() -> Store<FuelingState, FuelingAction> {
        return Store(initialState: FuelingState(forPreview: true),
                     reduce: FuelingReducer(),
                     name: "Test Fueling Store")
    }

    @Test func fuelTests() async throws {
        let store = createStore()

        let vehicle = try #require(store.vehicles.first)
        #expect(vehicle.name == "Honda Accord")

        let fuelings = vehicle.fuelingsByTimestamp()
        #expect(fuelings.count == 2)

        var dateTime: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd HH:mm"
            return formatter.string(from: Date.now)
        }
        let fuel = try #require(fuelings.first)
        #expect(fuel.dateTime == dateTime)
        #expect(fuel.miles() == 111)
        let last = try #require(fuelings.last)
        #expect(last.miles() == 210)
    }

    @Test func fuelFromFuelDataTest() async throws {
        let fuelData = FuelData(odometer: 100,
                                amount: 3.456,
                                cost: 17.23)
        let fuel = Fuel(from: fuelData)
        #expect(fuel.odometer == fuelData.odometer)
        #expect(fuel.amount == fuelData.amount)
        #expect(fuel.cost == fuelData.cost)
    }
}
