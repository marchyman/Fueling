//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI

struct FuelingInfoView: View {
    @Environment(\.dismiss) var dismiss

    var fueling: Fuel

    private let testIDs = TestIDs.FuelingInfoView.self

    var body: some View {
        VStack {
            let miles = fueling.miles()
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 50) {
                    GridRow {
                        Text("Fuel used:")
                            .accessibilityIdentifier(testIDs.fuelUsedID)
                        Text("\(fueling.amount, specifier: "%.3f")")
                            .monospacedDigit()
                    }
                    GridRow {
                        Text("Miles driven:")
                            .accessibilityIdentifier(testIDs.milesDrivenID)
                        Text("\(miles, format: .number)")
                            .monospacedDigit()
                    }
                    GridRow {
                        Text("Miles/gallon:")
                            .accessibilityIdentifier(testIDs.mpgID)
                        Text(
                            "\(mpg(miles: miles, gallons: fueling.amount), specifier: "%0.1f")"
                        )
                        .monospacedDigit()
                    }
                    GridRow {
                        Text("Cost/gallon:")
                            .accessibilityIdentifier(testIDs.cpgID)
                        Text(
                            "\(cpg(cost: fueling.cost, gallons: fueling.amount), format: .currency(code: "usd"))"
                        )
                        .monospacedDigit()
                    }
                    GridRow {
                        Text("Cost/mile:")
                            .accessibilityIdentifier(testIDs.cpmID)
                        Text(
                            "\(cpm(cost: fueling.cost, miles: miles), format: .currency(code: "usd"))"
                        )
                        .monospacedDigit()
                    }
                }
            } label: {
                Text("Fueling on \(fueling.dateTime)")
                    .accessibilityIdentifier(testIDs.dateTimeID)
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
