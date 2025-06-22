//
// Copyright 2024 Marco S Hyman
// https://www.snafu.org/
//

import SwiftUI
import UDF

struct FuelingEditView: View {
    @Environment(Store<FuelingState, FuelingAction>.self) var store
    @Environment(\.dismiss) var dismiss

    @Bindable var fueling: Fuel

    var body: some View {
        Text("compile")
        /*
        VStack {
            Text("Edit Fuel")
                .font(.title)
                .padding(.bottom)

            Form {
                Text(fueling.vehicle?.name ?? "unknown").font(.headline)

                LabeledContent("Cost") {
                    TextField(
                        "Required",
                        value: $fueling.cost,
                        format: .currency(code: "usd")
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }

                LabeledContent("Number of gallons") {
                    TextField(
                        "Required",
                        value: $fueling.amount,
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }

                LabeledContent("Current odometer") {
                    TextField(
                        "Required",
                        value: $fueling.odometer,
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
            }
            .frame(height: 250)
            HStack {
                Spacer()
                Button("Dismiss") {
                    state.update(fuel: fueling)
                    state.sendAppContext()
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
        */
    }
}

#Preview {
    let state = FuelingState(forPreview: true)
    let fueling = state.vehicles.first!.fuelings.first!
    FuelingEditView(fueling: fueling)
}
