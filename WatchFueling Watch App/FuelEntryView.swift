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
    @State private var miles: Double = 0
    @State private var present: KeypadSelect?

    enum KeypadSelect: Identifiable, CaseIterable {
        case cost
        case gallons
        case miles

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
                    Text("Miles")
                    Text("\(miles, format: .number)")
                        .onTapGesture { present = .miles }
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
                                         miles: miles)
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
                case .miles:
                    KeypadView(value: $miles)
                }
            }
        }
    }
}

#Preview {
    FuelEntryView(vehicle: Vehicle.previewVehicle)
        .environment(WatchState())
}
