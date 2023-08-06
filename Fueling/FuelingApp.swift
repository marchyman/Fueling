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

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Vehicle.self)
    }
}
