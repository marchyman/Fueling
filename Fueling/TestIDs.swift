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
    enum FuelingInfoView {
        static let fuelUsedID = "FuelingInfoView.staticText.fuelUsed"
        static let milesDrivenID = "FuelingInfoView.staticText.milesDriven"
        static let mpgID = "FuelingInfoView.staticText.mpg"
        static let cpgID = "FuelingInfoView.staticText.cpg"
        static let cpmID = "FuelingInfoView.staticText.cpm"
        static let dateTimeID = "FuelingInfoView.staticText.dataTime"
        static let dismissID = "FuelingInfoView.buttons.dismiss"
    }
    enum AddVehicleView {
        static let vehicleNameID = "AddVehicleView.textField.vehicleName"
        static let odometerID = "AddVehicleView.textField.odometer"
        static let cancelButtonID = "AddVehicleView.button.cancel"
        static let addButtonID = "AddVehicleView.button.add"
    }
    enum AddFuelView {
        static let nameID = "AddFuelView.staticText.name"
        static let costID = "AddFuelView.textField.cost"
        static let gallonsID = "AddFuelView.textField.gallons"
        static let odometerID = "AddFuelView.textField.odometer"
        static let cancelButtonID = "AddFuelView.button.cancel"
        static let addButtonID = "AddFuelView.button.add"
    }
}
