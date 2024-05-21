//
//  FuelEntryView.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/18/24.
//

import SwiftUI

struct FuelEntryView: View {
    @Environment(WatchState.self) private var state
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
        NavigationStack {
            Grid(alignment: .leading, horizontalSpacing: 20,
                 verticalSpacing: 25) {
                GridRow {
                    Text("Cost")
                    Text("\(cost, format: .currency(code: "usd"))")
                        .onTapGesture { present = .cost }
                }
                GridRow {
                    Text("Gallons")
                    Text("\(gallons, specifier: "%.3f")")
                        .onTapGesture { present = .gallons }
                }
                GridRow {
                    Text("Odometer")
                    Text("\(odometer, format: .number)")
                        .onTapGesture { present = .odometer }
                }
            }
            .navigationTitle(vehicle.name)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        state.putFueling(vehicle: vehicle,
                                         cost: cost,
                                         gallons: gallons,
                                         odometer: odometer)
                        dismiss()
                    } label: {
                        Label("Refresh", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .sheet(item: $present) { select in
                switch select {
                case .cost:
                    KeypadView(value: $cost)
                case .gallons:
                    KeypadView(value: $gallons)
                case .odometer:
                    KeypadView(value: $odometer)
                }
            }
        }
    }
}

#Preview {
    FuelEntryView(vehicle: Vehicle.previewVehicle)
        .environment(WatchState())
}
