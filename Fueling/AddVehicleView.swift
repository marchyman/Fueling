//
//  AddVehicleView.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/5/23.
//

import SwiftUI
import SwiftData

struct AddVehicleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var odometer: Int?
    @Query private var vehicles: [Vehicle]

    var body: some View {
        VStack {
            Text("Add Vehicle")
                .font(.title)
                .padding(.bottom)

            Form {
                LabeledContent("Vehicle Name:") {
                    TextField("Required", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                LabeledContent("Current odometer:") {
                    TextField("Required",
                              value: $odometer,
                              format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
            }
            .frame(height: 160)
            HStack {
                Spacer()
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                Button("Add") {
                    addVehicle()
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(!validInput())
            }
            Spacer()
        }
    }

    // name must not be empty or already exist
    // odometer must be > 0
    private func validInput() -> Bool {
        guard let odometer else { return false }
        guard !name.isEmpty && odometer > 0 else { return false }
        return !vehicles.contains(where: { $0.name == name })
    }

    private func addVehicle() {
        guard let odometer else { return }
        let newVehicle = Vehicle(name: name, odometer: odometer)
        modelContext.insert(newVehicle)
    }
}

#Preview {
    AddVehicleView()
        .modelContainer(for: Vehicle.self, inMemory: true)
}
