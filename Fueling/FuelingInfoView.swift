//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI

struct FuelingInfoView: View {
    @Environment(\.dismiss) var dismiss

    var fueling: Fuel

    var body: some View {
        VStack {
            let miles = fueling.miles()
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 50) {
                    GridRow {
                        Text("Fuel used:")
                        Text("\(fueling.amount, specifier: "%.3f")")
                            .monospacedDigit()
                    }
                    GridRow {
                        Text("Miles driven:")
                        Text("\(miles, format: .number)")
                            .monospacedDigit()
                    }
                    GridRow {
                        Text("Miles/gallon:")
                        Text(
                            "\(mpg(miles: miles, gallons: fueling.amount), specifier: "%0.1f")"
                        )
                        .monospacedDigit()
                    }
                    GridRow {
                        Text("Cost/gallon:")
                        Text(
                            "\(cpg(cost: fueling.cost, gallons: fueling.amount), format: .currency(code: "usd"))"
                        )
                        .monospacedDigit()
                    }
                    GridRow {
                        Text("Cost/mile:")
                        Text(
                            "\(cpm(cost: fueling.cost, miles: miles), format: .currency(code: "usd"))"
                        )
                        .monospacedDigit()
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
}

extension FuelingInfoView {

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
    let state = FuelingState(forPreview: true)
    let vehicle = state.vehicles.first!
    FuelingInfoView(fueling: vehicle.fuelings.first!)
}
