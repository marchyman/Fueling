//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI
import UDF

struct FuelEntryView: View {
    @Environment(Store<WatchState, WatchAction>.self) private var store
    @Environment(\.dismiss) var dismiss

    var vehicle: Vehicle

    @State private var cost: Double = 0
    @State private var gallons: Double = 0
    @State private var odometer: Double = 0
    @State private var present: KeypadSelect?

    enum KeypadSelect: Identifiable, CaseIterable {
        case cost
        case gallons
        case odometer

        var id: Self { self }
    }

    var body: some View {
        Grid(
            alignment: .leading, horizontalSpacing: 20,
            verticalSpacing: 25
        ) {
            GridRow {
                Text("Cost")
                Text("\(cost, format: .currency(code: "usd"))")
                    .monospacedDigit()
                    .onTapGesture { present = .cost }
            }
            GridRow {
                Text("Gallons")
                Text("\(gallons, specifier: "%.3f")")
                    .monospacedDigit()
                    .onTapGesture { present = .gallons }
            }
            GridRow {
                Text("Odometer")
                Text("\(odometer, format: .number)")
                    .monospacedDigit()
                    .onTapGesture { present = .odometer }
            }
        }
        .navigationTitle(vehicle.name)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    store.send(.sendFuelButtonTapped) {
                        if store.sendStatus == .sendRequested {
                            store.watchSession?.putFueling(vehicle: vehicle,
                                                           cost: cost,
                                                           gallons: gallons,
                                                           odometer: odometer)
                        }
                    }
                    dismiss()
                } label: {
                    Label("Upload", systemImage: "square.and.arrow.up")
                }
            }
        }
        .sheet(item: $present) { select in
            switch select {
            case .cost:
                KeypadView(value: $cost, title: "Cost")
            case .gallons:
                KeypadView(value: $gallons, title: "Gallons")
            case .odometer:
                KeypadView(value: $odometer, title: "Odometer")
            }
        }
    }
}

#Preview {
    NavigationStack {
        FuelEntryView(vehicle: Vehicle.previewVehicle)
            .environment(Store(initialState: WatchState(),
                               reduce: WatchReducer(),
                               name: "Watch Store"))
    }
}
