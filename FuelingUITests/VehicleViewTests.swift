//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import XCTest

@MainActor
final class BxVehicleViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let testIDs = TestIDs.VehicleView.self

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation
        // of each test method in the class.

        // In UI tests it is usually best to stop immediately when a
        // failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as
        // interface orientation - required for your tests before they run.
        // The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVehicleView() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        XCTAssert(app.navigationBars["Vehicle Fuel Use"].exists)

        // check for many of the elements that make up the view
        XCTAssert(app.buttons[testIDs.addFuelButtonID].exists)
        XCTAssert(app.staticTexts[testIDs.startMilesID].exists)
        XCTAssert(app.staticTexts[testIDs.initialMilesID].exists)
        XCTAssert(app.staticTexts[testIDs.totalCostID].exists)
        XCTAssert(app.staticTexts[testIDs.fuelUsedID].exists)
        XCTAssert(app.staticTexts[testIDs.milesDrivenID].exists)
        XCTAssert(app.staticTexts[testIDs.mpgID].exists)
        XCTAssert(app.staticTexts[testIDs.cpgID].exists)
        XCTAssert(app.staticTexts[testIDs.cpmID].exists)
        XCTAssert(app.staticTexts[testIDs.recentRefuelingsID].exists)
    }

    func testRefuelingItems() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        XCTAssert(app.staticTexts.matching(identifier: testIDs.fuelingDateTimeID).count == 2)
    }

    func testAddButton() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        app.buttons[testIDs.addFuelButtonID].tap()
        XCTAssert(app.staticTexts[testIDs.addFuelViewID].exists)
    }

    func testInfoTap() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        let entry = app.staticTexts.matching(identifier: testIDs.fuelingDateTimeID).firstMatch
        XCTAssert(entry.exists)
        entry.tap()
        XCTAssert(app.otherElements[testIDs.fuelingInfoViewID].exists)
    }

    func testEditPress() {
        app = XCUIApplication()
        app.launchArguments.append("-TESTING")
        app.launch()

        app.buttons[TestIDs.ContentView.vehicleButtonID("Honda Accord")].tap()
        let entry = app.staticTexts.matching(identifier: testIDs.fuelingDateTimeID).firstMatch
        XCTAssert(entry.exists)
        entry.press(forDuration: 1.0)
        XCTAssert(app.collectionViews[testIDs.fuelingEditViewID].exists)
    }
}
