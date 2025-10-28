//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import Foundation
import SwiftData
import Testing
import UDF

@testable import Fueling_Watch_App

@MainActor
struct WatchTests {
    func createStore() -> Store<WatchState, WatchEvent> {
        return Store(initialState: WatchState(),
                     reduce: WatchReducer())
    }

    @Test func watchVehicleTest() async throws {
        let goodPlist: [String: Any] = [
            "Vehicle 1": [
                "cost": 1.23,
                "gallons": 0.24,
                "miles": 10
            ],
            "Vehicle 2": [
                "cost": 10.34,
                "gallons": 2.13,
                "miles": 297
            ]
        ]

        var vehicles: [Vehicle] = []
        for (key, value) in goodPlist {
            let vehicle = try Vehicle(from: key, value: value)
            #expect(vehicle.name == key)
            vehicles.append(vehicle)
        }

        #expect(vehicles.count == 2)
        #expect(vehicles[0] < vehicles[1])

        let badPlist: [String: Any] = [
            "Bad vehicle": "not the expected dictionary",
            "Another Bad Vehicle": ["miles": 0]
        ]

        for (key, value) in badPlist {
            _ = #expect(throws: Vehicle.VehicleModelError.self) {
                try Vehicle(from: key, value: value)
            }
        }

        #expect(Vehicle.previewVehicle.id == "Test Vehicle")
        #expect(Vehicle.previewVehicle.mpg == 1185.0 / 22.583)
        #expect(Vehicle.previewVehicle.cpg == 123.76 / 22.583)
    }

    @Test func watchStateTests() async throws {
        let store = createStore()
        #expect(store.vehicles.isEmpty)
        #expect(store.watchSession == nil)
        #expect(!store.fetching)
        #expect(store.sendStatus == .idle)
    }

    @Test func watchReducerTests() async throws {
        let store = createStore()
        // send with no active session
        await store.send(.contentViewAppeared)
        #expect(store.fetchStatus == .idle)

        await store.send(.downloadButtonTapped)
        #expect(store.fetchStatus == .idle)

        await store.send(.sendFuelButtonTapped)
        #expect(store.sendStatus == .idle)

        // create a testing watch session.  Ignore the "unused" warning.
        // watchSession keeps the session alive until the test ends
        let watchSession = WatchSession(store: store)
        try await Task.sleep(for: .milliseconds(200))
        #expect(store.watchSession != nil)

        await store.send(.watchSessionReachable)
        #expect(store.fetchStatus == .fetchRequested)
        await store.send(.watchSendError(fetchRequest: true))
        #expect(store.fetchStatus == .idle)

        await store.send(.contentViewAppeared)
        #expect(store.fetchStatus == .fetchRequested)

        // should not change status as a fetch is already pending
        await store.send(.watchSessionReachable)
        #expect(store.fetchStatus == .fetchRequested)

        await store.send(.downloadButtonTapped)
        #expect(store.fetchStatus == .dupRequest)

        await store.send(.watchSendError(fetchRequest: true))
        #expect(store.fetchStatus == .idle)

        await store.send(.downloadButtonTapped)
        #expect(store.fetchStatus == .fetchRequested)

        await store.send(.receivedAppContext([Vehicle.previewVehicle]))
        #expect(!store.fetching)
        let vehicle = try #require(store.vehicles.first)
        #expect(vehicle.name == Vehicle.previewVehicle.name)

        await store.send(.sendFuelButtonTapped)
        #expect(store.sendStatus == .sendRequested)

        await store.send(.sendFuelButtonTapped)
        #expect(store.sendStatus == .dupRequest)

        await store.send(.watchSendError(fetchRequest: false))
        #expect(store.sendStatus == .idle)

        await store.send(.sendFuelButtonTapped)
        #expect(store.sendStatus == .sendRequested)

        await store.send(.receivedFuelingResponse)
        #expect(store.sendStatus == .idle)
    }
}
