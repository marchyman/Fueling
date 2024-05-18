//
//  WatchFuelingApp.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/2/24.
//

import SwiftUI

@main
struct WatchFueling_Watch_AppApp: App {
    @State var watchState = WatchState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(watchState)
        }
    }
}
