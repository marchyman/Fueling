//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import SwiftUI
import UDF

@main
struct FuelingApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(FuelingState())
        }
    }
}
