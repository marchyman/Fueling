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
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(state.vehicles, id: \.self) { vehicle in
                    Text(vehicle)
                }
            }
            .listStyle(.carousel)
            .task {
                state.getVehicles()
            }
            .navigationTitle("Fueling")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        state.getVehicles()
                    } label: {
                        Label("Refresh", systemImage: "square.and.arrow.down")
                    }
                }
            }
        } detail: {
            Text("\(selection ?? "unk") detail view")
        }
    }
}

#Preview {
    ContentView()
        .environment(WatchState())
}
