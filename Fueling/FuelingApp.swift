//
//  FuelingApp.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/5/23.
//

import SwiftUI

@main
struct FuelingApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(FuelingState())
        }
    }
}
