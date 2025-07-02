//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import XCTest

@MainActor
final class WatchUITests: XCTestCase {

    private var app: XCUIApplication!
    private let testID = TestID.self

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

    func testWatch() {
        app = XCUIApplication()
        // replace TESTING with UITESTING
        app.launchArguments = ["-UITESTING"]
        app.launch()

        // get current vehicles. Requires the iOS companion app to be
        // have one vehicle loaded.  I use "New Vehicle" with 7 miles and
        // no fuel entries.

        XCTAssert(app.staticTexts["Fueling"].exists)
        XCTAssert(app.buttons[testID.downloadButton].exists)
        app.buttons[testID.downloadButton].tap()
        XCTAssert(app.buttons[testID.vehicleButton].waitForExistence(timeout: 3))

        // check the vehicle detail view

        app.buttons[testID.vehicleButton].tap()
        XCTAssert(app.staticTexts[testID.totalCost].exists)
        XCTAssert(app.staticTexts[testID.totalGallons].exists)
        XCTAssert(app.staticTexts[testID.totalMiles].exists)
        XCTAssert(app.staticTexts[testID.totalMPG].exists)
        XCTAssert(app.staticTexts[testID.totalCPG].exists)
        XCTAssert(app.buttons[testID.fuelEntryButton].exists)
        app.buttons[testID.fuelEntryButton].tap()

        // check the fuel entry view

        XCTAssert(app.buttons[testID.entryCost].exists)
        XCTAssert(app.buttons[testID.entryCost].label == "$0.00")
        XCTAssert(app.buttons[testID.entryGallons].exists)
        XCTAssert(app.buttons[testID.entryGallons].label == "0.000")
        XCTAssert(app.buttons[testID.entryOdometer].exists)
        XCTAssert(app.buttons[testID.entryOdometer].label == "0")
        XCTAssert(app.buttons[testID.entryUploadButton].exists)

        // cost data entry

        // this fails testing because even though the button is visible the
        // test framework tries to scroll to it and fails. Manual testing
        // has no issues. Until I figure out a workaround I'll not write
        // more tests.

        // app.buttons[testID.entryCost].tap()
    }
}
