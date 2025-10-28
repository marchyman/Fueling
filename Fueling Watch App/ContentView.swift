//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI
import UDF

struct ContentView: View {
    @Environment(Store<WatchState, WatchEvent>.self) private var store
    @State private var selectedVehicle: Vehicle?
    @State private var path = NavigationPath()

    private let testID = TestID.self

    var body: some View {
        NavigationSplitView {
            Group {
                if store.vehicles.isEmpty {
                    ContentUnavailableView {
                        Label("No Vehicles", systemImage: "iphone.slash")
                    } description: {
                        Text(
                            "Tap on the download button to fetch the list of vehicles from your phone."
                        )
                    }
                } else {
                    List(store.vehicles, selection: $selectedVehicle) { vehicle in
                        NavigationLink(value: vehicle) {
                            Text(vehicle.name)
                                .accessibilityIdentifier(testID.vehicleButton)
                        }
                    }
                    .listStyle(.carousel)
                }
            }
            .navigationTitle("Fueling")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        store.send(.downloadButtonTapped) {
                            if store.fetchStatus == .fetchRequested {
                                store.watchSession?.getVehicles()
                            }
                        }
                    } label: {
                        Label("Download", systemImage: "square.and.arrow.down")
                    }
                    .accessibilityIdentifier(testID.downloadButton)
                }
            }
        } detail: {
            NavigationStack(path: $path) {
                if let selectedVehicle {
                    VehicleDetailView(vehicle: selectedVehicle)
                } else {
                    ContentUnavailableView("Select a vehicle", systemImage: "car")
                }
            }
        }
        .opacity(store.fetching ? 0.3 : 1.0)
        .overlay {
            ProgressView()
                .opacity(store.fetching ? 1.0 : 0.0)
        }
        .animation(.easeInOut, value: store.fetching)
        .task {
            // this will fetch known vehicles if needed
            store.send(.contentViewAppeared) {
                if store.fetchStatus == .fetchRequested {
                    store.watchSession?.getVehicles()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Store(initialState: WatchState(),
                           reduce: WatchReducer(),
                           name: "Watch Store"))
}
