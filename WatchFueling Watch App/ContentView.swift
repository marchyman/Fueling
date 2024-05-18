//
//  ContentView.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/2/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(WatchState.self) private var state
    @State private var selection: String?

    var body: some View {
        Text("Start here")
            .padding()
            .task {
                state.getVehicles()
            }
    }
}

#Preview {
    ContentView()
        .environment(WatchState())
}
