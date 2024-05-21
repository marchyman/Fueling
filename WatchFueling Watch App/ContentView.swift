//
//  ContentView.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/2/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(WatchState.self) private var state
    @State private var selection: Vehicle.ID?

    var body: some View {
        NavigationSplitView {
            Group {
                if state.vehicles.isEmpty {
                    ContentUnavailableView {
                        Label("No Vehicles", systemImage: "wifi.slash")
                    } description: {
                        Text("Click the download button to re-try.")
                    }
                } else {
                    List(state.vehicles, selection: $selection) { vehicle in
                        Text(vehicle.name)
                    }
                    .listStyle(.carousel)
                }
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
            if let vehicle = state.vehicles.first(where: { $0.id == selection }) {
                VehicleDetailView(vehicle: vehicle)
            } else {
                ContentUnavailableView("Select a vehicle", systemImage: "car")
            }
        }
        .opacity(state.fetching ? 0.3 : 1.0)
        .overlay {
            ProgressView()
                .opacity(state.fetching ? 1.0 : 0)
        }
        .animation(.easeInOut, value: state.fetching)
        .task {
            // request the application context. Try up to 5 times with a
            // pause between tries in case the communications channel is
            // not yet set up.
            if state.vehicles.isEmpty {
                state.fetching = true
                for _ in 1...5 {
                    if state.getVehicles() {
                        break
                    }
                    try? await Task.sleep(for: .seconds(1))
                }
                state.fetching = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(WatchState())
}
