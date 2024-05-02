//
//  FuelingInfoView.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/1/24.
//

import SwiftData
import SwiftUI

struct FuelingInfoView: View {
    @Environment(\.dismiss) var dismiss
    var fueling: Fuel

    var body: some View {
        VStack {
            let (miles, gallons, cost) = fueling.fuelStats()
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 50) {
                    GridRow {
                        Text("Fuel used:")
                        Text("\(fueling.amount, specifier: "%.3f")")
                    }
                    GridRow {
                        Text("Miles driven:")
                        Text("\(miles, format: .number)")
                    }
                    GridRow {
                        Text("Miles/gallon:")
                        Text("\(mpg(miles: miles, gallons: gallons), specifier: "%0.1f")")
                    }
                    GridRow {
                        Text("Cost/gallon:")
                        Text("\(cpg(cost: cost, gallons: gallons), format: .currency(code: "usd"))")
                    }
                    GridRow {
                        Text("Cost/mile:")
                        Text("\(cpm(cost: cost, miles: miles), format: .currency(code: "usd"))")
                    }
                }
            } label: {
                Text("Fueling on \(fueling.dateTime)")
            }
            HStack {
                Spacer()
                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }

    private func mpg(miles: Int, gallons: Double) -> Double {
        if gallons != 0 {
            return Double(miles) / gallons
        }
        return 0
    }

    private func cpg(cost: Double, gallons: Double) -> Double {
        if gallons != 0 {
            return cost / gallons
        }
        return 0
    }

    private func cpm(cost: Double, miles: Int) -> Double {
        if miles != 0 {
            return cost / Double(miles)
        }
        return 0
    }
}

#Preview {
    let container = Vehicle.preview
    let fetchDescriptor = FetchDescriptor<Vehicle>(
        predicate: #Predicate { $0.name == "Honda Accord" }
    )
    let vehicle = try! container.mainContext.fetch(fetchDescriptor)[0]
    return FuelingInfoView(fueling: vehicle.fuelings.first!)
        .modelContainer(for: Vehicle.self, inMemory: true)
}
