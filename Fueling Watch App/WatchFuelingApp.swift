//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import SwiftUI

@main
struct WatchFuelingApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(WatchState())
        }
    }
}
