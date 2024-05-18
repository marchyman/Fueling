//
//  VehicleDetailView.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/18/24.
//

import SwiftUI

struct VehicleDetailView: View {
    @Environment(WatchState.self) private var state
    var vehicle: String

    var body: some View {
        NavigationStack {
            VStack {
                Grid(alignment: .leading, horizontalSpacing: 20) {
                    GridRow {
                        Text("Cost")
                        Text("\(state.cost, format: .currency(code: "usd"))")
                    }
                    GridRow {
                        Text("Gallons")
                        Text("\(state.gallons, specifier: "%.3f")")
                    }
                    GridRow {
                        Text("Miles")
                        Text("\(state.miles, format: .number)")
                    }
                    Divider()
                    GridRow {
                        Text("MPG")
                        Text("\(state.mpg, specifier: "%0.1f")")
                    }
                    GridRow {
                        Text("$PG")
                        Text("\(state.cpg, format: .currency(code: "usd"))")
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle(vehicle)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        //
                    } label: {
                        Label("Add", systemImage: "gauge.medium.badge.plus")
                    }
                }
            }
            .opacity(state.fetching ? 0.3 : 1.0)
            .overlay {
                ProgressView()
                    .opacity(state.fetching ? 1.0 : 0)

            }
            .animation(.easeInOut, value: state.fetching)
        }
        .task {
            state.getVehicle(named: vehicle)
        }
    }
}

#Preview {
    VehicleDetailView(vehicle: "Test vehicle")
        .environment(WatchState())
}
