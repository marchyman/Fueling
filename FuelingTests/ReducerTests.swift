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
struct ReducerTests {

    // forPreview uses an in memory database
    func createStore() -> Store<FuelingState, FuelingEvent> {
        return Store(initialState: FuelingState(forPreview: true),
                     reduce: FuelingReducer(),
                     name: "Test Fueling Store")
    }

    func createFuelData(odometer: Int = 0,
                        amount: Double = 4.0,
                        cost: Double = 20.0) -> FuelData {
        return FuelData(odometer: odometer, amount: amount, cost: cost)
    }

    @Test func addDeleteReducerTests() async throws {
        let store = createStore()

        // verify the test store is as expected
        let count = store.vehicles.count
        #expect(count == 2)
        #expect(store.vehicles.first?.name == "Honda Accord")
        #expect(store.vehicles.last?.name == "KTM790")

        // verify the test fuel entries
        let fetchDescriptor = FetchDescriptor<Fuel>()
        let entries = try store.fuelingDB.context.fetch(fetchDescriptor)
        #expect(entries.count == 2)

        // add a vehicle
        let testName = "TestName"
        await store.send(.addVehicleButtonTapped(testName, 123))
        #expect(store.vehicles.count == count + 1)

        // Add a fuel entry to the test venicle
        let fuel = createFuelData()
        await store.send(.addFuelReceived(testName, fuel))

        // again, using a different event
        await store.send(.addFuelButtonTapped(testName, fuel))

        // should be two more entries
        let newEntries = try store.fuelingDB.context.fetch(fetchDescriptor)
        #expect(newEntries.count == entries.count + 2)

        let testVehicle = try #require(store.vehicles.first(where: {
            $0.name == testName
        }))
        store.send(.onDeleteRequested(vehicle: testVehicle))
        #expect(store.vehicles.count == count)

        // The added fueling entries should be gone, too
        let finalEntries = try store.fuelingDB.context.fetch(fetchDescriptor)
        #expect(finalEntries.count == entries.count)
    }

    @Test func phoneSessionReducerTest() async throws {
        let store = createStore()
        #expect(store.phoneSession == nil)
        let phoneSession = PhoneSession(store: store)
        store.send(.phoneSessionActivated(phoneSession))
        #expect(store.phoneSession == phoneSession)
    }

    @Test func editReducerTest() async throws {
        let store = createStore()
        let fetchDescriptor = FetchDescriptor<Fuel>()
        let fuelEntries = try store.fuelingDB.context.fetch(fetchDescriptor)
        let fuelEntry = try #require(fuelEntries.first)
        let key = fuelEntry.timestamp
        let fuelUpdate = createFuelData(odometer: fuelEntry.odometer + 100,
                                        amount: fuelEntry.amount + 4,
                                        cost: fuelEntry.cost + 20.0)
        await store.send(.editFuelUpdateButtonTapped(key, fuelUpdate))

        // grab the entry just updated
        #expect(fuelEntry.odometer == fuelUpdate.odometer)
        #expect(fuelEntry.amount == fuelUpdate.amount)
        #expect(fuelEntry.cost == fuelUpdate.cost)
    }

    @Test func fuelErrorTest() async throws {
        let store = createStore()
        let name = "bad vehicle"
        let fuelData = createFuelData()
        await store.send(.addFuelReceived(name, fuelData))
        #expect(store.errorMessage != nil)
        let msg = store.errorMessage

        let key = Date.now
        await store.send(.editFuelUpdateButtonTapped(key, fuelData))
        #expect(store.errorMessage != nil)
        #expect(store.errorMessage != msg)
    }
}
