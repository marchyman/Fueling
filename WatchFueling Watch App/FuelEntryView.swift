//
//  FuelEntryView.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/18/24.
//

import SwiftUI

struct FuelEntryView: View {
    @Environment(WatchState.self) private var state

    @State private var cost: Double = 0
    @State private var gallons: Double = 0
    @State private var miles: Double = 0
    @State private var presented = false

    var body: some View {
        NavigationStack {
            Grid(alignment: .leading, horizontalSpacing: 20,
                 verticalSpacing: 25) {
                GridRow {
                    Text("Cost")
                    Text("\(cost, format: .currency(code: "usd"))")
                        .onTapGesture { presented.toggle() }
                }
                GridRow {
                    Text("Gallons")
                    Text("\(gallons, specifier: "%.3f")")
                }
                GridRow {
                    Text("Miles")
                    Text("\(miles, format: .number)")
                }
            }
            .navigationTitle(state.name.isEmpty ? "test" : state.name)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        // state.getVehicles()
                    } label: {
                        Label("Refresh", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $presented) {
                KeypadView(value: $cost)
            }
        }
    }
}

#Preview {
    FuelEntryView()
        .environment(WatchState())
}
