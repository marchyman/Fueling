//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
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
                        Label("No Vehicles", systemImage: "iphone.slash")
                    } description: {
                        Text("Tap on the download button to fetch the list of vehicles from your phone.")
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
                        Label("Download", systemImage: "square.and.arrow.down")
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
            // when the list of known vehicles is empty send a message
            // to the companion app requesting that it send an
            // application context update.  The context contains known
            // vehicles along with their current stats. Try to send
            // the getVehicles message up to 5 times with a
            // pause between tries in case the communications channel is
            // not yet set up. However, sending the message is no guarantee
            // that the companion app will respond.
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
