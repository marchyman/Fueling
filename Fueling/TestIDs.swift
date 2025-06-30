//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import Foundation

enum TestIDs {
    enum ContentView {
        static let noContentID = "ContentView.view.nocontent"
        static let editButtonID = "ContentView.button.edit"
        static let addButtonID = "ContentView.button.add"
        static let versionStringID = "ContentView.statictext.version"

        static func vehicleButtonID(_ name: String) -> String {
            "ContentView.button.vehicle \(name)"
        }
    }
    enum VehicleView {
        static let addFuelButtonID = "VehicleView.button.addFuel"
        static let startMilesID = "VehicleView.staticText.start"
        static let initialMilesID = "VehicleView.staticText.miles"
        static let totalCostID = "VehicleView.staticText.totalCost"
        static let fuelUsedID = "VehicleView.staticText.fuelUsed"
        static let milesDrivenID = "VehicleView.staticText.milesDriven"
        static let mpgID = "VehicleView.staticText.milesPerGallon"
        static let cpgID = "VehicleView.staticText.costPerGallon"
        static let cpmID = "VehicleView.staticText.costPerMile"
        static let recentRefuelingsID = "VehicleView.staticText.recentRefuelings"
        static let fuelingDateTimeID = "VehicleView.staticText.dateTime"
        static let addFuelViewID = "VehicleView.staticText.addFuelView"
        static let fuelingInfoViewID = "VehicleView.otherElement.fuelingInfoView"
        static let fuelingEditViewID = "VehicleView.collectionView.fuelingEditView"
    }
}
