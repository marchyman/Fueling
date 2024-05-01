//
//  FuelingView.swift
//  Fueling
//
//  Created by Marco S Hyman on 5/1/24.
//

import SwiftData
import SwiftUI

struct FuelingView: View {
    var fueling: Fuel

    var body: some View {
        Grid(alignment: .trailing, horizontalSpacing: 30) {
            GridRow {
                Text("\(fueling.dateTime)")
                Text("\(fueling.amount, specifier: "%.3f")")
                Text("$\(fueling.cost / 100).\(fueling.cost % 100)")
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
    let fueling = vehicle.fuelings[0]
    return FuelingView(fueling: fueling)
}
