//
//  VehicleView.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/7/23.
//

import SwiftUI

struct VehicleView: View {
    @Environment(\.modelContext) private var modelContext
    var vehicle: Vehicle

    var body: some View {
        VStack {
            GroupBox {
                Grid(alignment: .leading) {
                    GridRow {
                        Text("Date added:")
                        Text(vehicle.initialTimestamp.formatted(date: .abbreviated,
                                                                time: .omitted))
                    }
                    GridRow {
                        Text("Odometer start:")
                        Text("\(vehicle.odometer)")
                    }
                }
            } label: {
                Text(vehicle.name )
            }
            .padding(.horizontal)
            Text("Recent refuelings")
                .font(.title)
            List {
                Text("list goes here")
            }
        }
        .navigationTitle("Vehicle Fuel Use")
    }
}

#Preview {
    ModelPreview { vehicle in
        NavigationStack {
            VehicleView(vehicle: vehicle)
        }
    }
}
