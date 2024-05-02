//
//  FuelingEditView.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/2/24.
//

import SwiftData
import SwiftUI

struct FuelingEditView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var fueling: Fuel

    var body: some View {
        VStack {
            Text("Edit Fuel")
                .font(.title)
                .padding(.bottom)

            Form {
                Text(fueling.vehicle?.name ?? "unknown").font(.headline)

                LabeledContent("Cost") {
                    TextField("Required",
                              value: $fueling.cost,
                              format: .currency(code: "usd"))
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }

                LabeledContent("Number of gallons") {
                    TextField("Required",
                              value: $fueling.amount,
                              format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }

                LabeledContent("Current odometer") {
                    TextField("Required",
                              value: $fueling.odometer,
                              format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
            }
            .frame(height: 250)
            HStack {
                Spacer()
                Button("Dismiss") {
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    let container = Vehicle.preview
    let fetchDescriptor = FetchDescriptor<Vehicle>(
        predicate: #Predicate { $0.name == "Honda Accord" }
    )
    let vehicle = try! container.mainContext.fetch(fetchDescriptor)[0]
    return FuelingEditView(fueling: vehicle.fuelings.first!)
        .modelContainer(for: Vehicle.self, inMemory: true)
}
