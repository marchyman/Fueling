//
//  VehicleView.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/7/23.
//

import SwiftData
import SwiftUI

struct VehicleView: View {
    @Environment(\.modelContext) private var modelContext
    var vehicle: Vehicle

    var body: some View {
        VStack {
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 30) {
                    GridRow {
                        Text("Odometer start:")
                        Text("\(vehicle.odometer)")
                    }
                    GridRow {
                        Text("Fuel used:")
                    }
                    GridRow {
                        Text("Miles driven:")
                    }
                    GridRow {
                        Text("Miles/Gallon:")
                    }
                    GridRow {
                        Text("Total cost:")
                    }
                    GridRow {
                        Text("Cost/Gallon")
                    }
                    GridRow {
                        Text("Cost/Mile")
                    }
                }
            } label: {
                HStack {
                    Text("\(vehicle.name)")
                    Spacer()
                    Text(vehicle.initialTimestamp.formatted(date: .abbreviated,
                                                            time: .omitted))
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            Text("Recent refuelings")
                .font(.title)
                .padding()

            Grid(alignment: .trailing, horizontalSpacing: 30) {
                GridRow {
                    Text("Date/Time").font(.headline)
                    Text("Odometer").font(.headline)
                    Text("Gallons").font(.headline)
                    Text("Cost").font(.headline)
                }
            }

            List {
                ForEach(fuelingsByTimestamp(vehicle.fuelings)) { fueling in
                    FuelingView(fueling: fueling)
                        .frame(maxWidth: .infinity)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Vehicle Fuel Use")
    }

    func fuelingsByTimestamp(_ fuelings: [Fuel]?) -> [Fuel] {
        guard let fuelings else { return [] }
        let descriptors: [SortDescriptor<Fuel>] = [
            .init(\.timestamp, order: .reverse)
        ]
        return fuelings.sorted(using: descriptors)
    }
}

#Preview {
    let container = Vehicle.preview
    let fetchDescriptor = FetchDescriptor<Vehicle>()
    let vehicle = try! container.mainContext.fetch(fetchDescriptor)[0]
    return NavigationStack {
        VehicleView(vehicle: vehicle)
    }
}
