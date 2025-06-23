//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import OSLog
import SwiftUI
import UDF

@main
struct WatchFuelingApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var session: WatchSession?
    @State private var store = Store(initialState: WatchState(),
                                     reduce: WatchReducer(),
                                     name: "Watch Store")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
        .onChange(of: scenePhase) {
            if session == nil {
                session = WatchSession(store: store)
                Logger(subsystem: "org.snafu", category: "WatchFuelingApp")
                    .notice("WatchSession initialized")
            }
        }
    }
}
