//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI
import UDF

struct VehicleDetailView: View {
    @Environment(Store<WatchState, WatchEvent>.self) private var store
    @Environment(\.dismiss) var dismiss

    @State var vehicle: Vehicle

    private let testID = TestID.self

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 20) {
            GridRow {
                Text("Cost")
                Text("\(vehicle.cost, format: .currency(code: "usd"))")
                    .monospacedDigit()
                    .accessibilityIdentifier(testID.totalCost)
            }
            GridRow {
                Text("Gallons")
                Text("\(vehicle.gallons, specifier: "%.3f")")
                    .monospacedDigit()
                    .accessibilityIdentifier(testID.totalGallons)
            }
            GridRow {
                Text("Miles")
                Text("\(vehicle.miles, format: .number)")
                    .monospacedDigit()
                    .accessibilityIdentifier(testID.totalMiles)
            }
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            GridRow {
                Text("MPG")
                Text("\(vehicle.mpg, specifier: "%0.1f")")
                    .monospacedDigit()
                    .accessibilityIdentifier(testID.totalMPG)
            }
            GridRow {
                Text("$PG")
                Text("\(vehicle.cpg, format: .currency(code: "usd"))")
                    .monospacedDigit()
                    .accessibilityIdentifier(testID.totalCPG)
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
                .accessibilityIdentifier(testID.fuelEntryButton)
            }
        }
        .onChange(of: store.vehicles) {
            if let updatedVehicle = store.vehicles.first(where: {
                $0.name == vehicle.name
            }) {
                vehicle = updatedVehicle
            } else {
                dismiss()
            }
        }
        .opacity(store.fetching ? 0.3 : 1.0)
        .overlay {
            ProgressView()
                .opacity(store.fetching ? 1.0 : 0)
        }
        .animation(.easeInOut, value: store.fetching)
    }
}

#Preview {
    NavigationStack {
        VehicleDetailView(vehicle: Vehicle.previewVehicle)
            .environment(Store(initialState: WatchState(),
                               reduce: WatchReducer(),
                               name: "Watch Store"))
    }
}
