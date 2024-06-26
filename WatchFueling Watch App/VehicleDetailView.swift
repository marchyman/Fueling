//
// Copyright 2024 Marco S Hyman
// See LICENSE file for info
// https://www.snafu.org/
//

import SwiftUI

struct VehicleDetailView: View {
    @Environment(WatchState.self) private var state
    var vehicle: Vehicle

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 20) {
            GridRow {
                Text("Cost")
                Text("\(vehicle.cost, format: .currency(code: "usd"))")
            }
            GridRow {
                Text("Gallons")
                Text("\(vehicle.gallons, specifier: "%.3f")")
            }
            GridRow {
                Text("Miles")
                Text("\(vehicle.miles, format: .number)")
            }
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            GridRow {
                Text("MPG")
                Text("\(vehicle.mpg, specifier: "%0.1f")")
            }
            GridRow {
                Text("$PG")
                Text("\(vehicle.cpg, format: .currency(code: "usd"))")
            }
        }
        .padding(.horizontal)
        .navigationTitle(vehicle.name)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                NavigationLink {
                    FuelEntryView(vehicle: vehicle)
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
}

#Preview {
    NavigationStack {
        VehicleDetailView(vehicle: Vehicle.previewVehicle)
            .environment(WatchState())
    }
}
