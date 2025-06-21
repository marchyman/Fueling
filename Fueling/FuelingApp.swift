//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import OSLog
import SwiftUI
import UDF

@main
struct FuelingApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var session: PhoneSession?
    @State private var store = Store(initialState: FuelingState(),
                                     reduce: FuelingReducer(),
                                     name: "Fueling Store")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
        .onChange(of: scenePhase) {
            // initialize phone/watch communications once
            if session == nil {
                session = PhoneSession(store: store)
                Logger(subsystem: "org.snafu", category: "FuelingApp")
                    .notice("PhoneSession initialized")
            }
        }
    }
}
