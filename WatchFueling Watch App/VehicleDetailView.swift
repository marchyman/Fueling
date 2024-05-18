//
//  VehicleDetailView.swift
//  WatchFueling Watch App
//
//  Created by Marco S Hyman on 5/18/24.
//

import SwiftUI

struct VehicleDetailView: View {
    var vehicle: String

    var body: some View {
        NavigationStack {
            VStack {
                Grid(alignment: .leading, horizontalSpacing: 20) {
                    GridRow {
                        Text("Cost")
                        Text("\(7.23, format: .currency(code: "usd"))")
                    }
                    GridRow {
                        Text("Gallons")
                        Text("\(1.23, specifier: "%.3f")")
                    }
                    GridRow {
                        Text("Miles")
                        Text("\(123, format: .number)")
                    }
                    Divider()
                    GridRow {
                        Text("MPG")
                        Text("\(123/1.23, specifier: "%0.1f")")
                    }
                    GridRow {
                        Text("CPG")
                        Text("\(7.23/1.23, format: .currency(code: "usd"))")
                    }
                }
            }
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
        }
    }
}

#Preview {
    VehicleDetailView(vehicle: "Test vehicle")
}
