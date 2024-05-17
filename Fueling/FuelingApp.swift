//
//  FuelingApp.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/5/23.
//

import SwiftUI
import SwiftData

@main
struct FuelingApp: App {
    @State var fuelingState = FuelingState()
    var phoneSession: PhoneSession!

    init() {
        phoneSession = PhoneSession(state: fuelingState)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(fuelingState)
        }
    }
}
