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
            List(state.vehicles, id: \.self, selection: $selection) { vehicle in
                Text(vehicle)
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
            if let selection {
                VehicleDetailView(vehicle: selection)
            } else {
                ContentUnavailableView("Select a vehicle", systemImage: "car")
            }
        }
        .opacity(state.vehicles.isEmpty ? 0.3 : 1.0)
        .overlay {
            ProgressView()
                .opacity(state.vehicles.isEmpty ? 1.0 : 0)
        }
        .animation(.easeInOut, value: state.vehicles.isEmpty)
    }
}

#Preview {
    ContentView()
        .environment(WatchState())
}
