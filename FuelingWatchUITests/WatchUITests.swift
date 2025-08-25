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

    func detailViewElements() {
        XCTAssert(app.staticTexts[testID.totalCost].exists)
        XCTAssert(app.staticTexts[testID.totalGallons].exists)
        XCTAssert(app.staticTexts[testID.totalMiles].exists)
        XCTAssert(app.staticTexts[testID.totalMPG].exists)
        XCTAssert(app.staticTexts[testID.totalCPG].exists)
        XCTAssert(app.buttons[testID.fuelEntryButton].exists)
    }

    func entryViewElements() {
        XCTAssert(app.buttons[testID.entryCost].exists)
        XCTAssert(app.buttons[testID.entryCost].label == "$0.00")
        XCTAssert(app.buttons[testID.entryGallons].exists)
        XCTAssert(app.buttons[testID.entryGallons].label == "0.000")
        XCTAssert(app.buttons[testID.entryOdometer].exists)
        XCTAssert(app.buttons[testID.entryOdometer].label == "0")
        XCTAssert(app.buttons[testID.entryUploadButton].exists)
    }

    func keycapViewElements() {
        let keycaps = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "." ]

        for val in keycaps {
            XCTAssert(app.buttons[testID.keycapButton(val)].exists)
        }
        XCTAssert(app.buttons[testID.keycapButtonDone].exists)
        XCTAssert(app.buttons[testID.keycapButtonCancel].exists)
        // there are 3 buttonw with the given identifier.
        // Use the first
        app.buttons[testID.keycapButtonCancel].firstMatch.tap()
    }

    func enterValue(_ string: String) {
        for char in string {
            app.buttons[testID.keycapButton(String(char))].tap()
        }
        app.buttons[testID.keycapButtonDone].firstMatch.tap()
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

        app.buttons[testID.vehicleButton].forceTapElement()
        detailViewElements()

        // check the fuel entry view
        app.buttons[testID.fuelEntryButton].tap()
        entryViewElements()

        // data entry tests

        // this failed testing because even though the button is visible the
        // test framework tries to scroll to it and fails. Manual testing
        // had no issues.  Now using "forceTapElement()" in place of "tap()"
        // to get around the issue.

        app.buttons[testID.entryCost].forceTapElement()
        keycapViewElements()

        app.buttons[testID.entryCost].forceTapElement()
        enterValue("4.56")
        XCTAssert(app.buttons[testID.entryCost].label == "$4.56")

        app.buttons[testID.entryGallons].forceTapElement()
        enterValue("1.03")
        XCTAssert(app.buttons[testID.entryGallons].label == "1.030")

        app.buttons[testID.entryOdometer].forceTapElement()
        enterValue("42")
        XCTAssert(app.buttons[testID.entryOdometer].label == "42")

        // upload the fueling entry
        app.buttons[testID.entryUploadButton].tap()

        // wait for the detail view to update and verify the values

        XCTAssert(app.staticTexts[testID.totalCost].waitForExistence(timeout: 3))
        // Wait longer, giving time for a response to be received from the
        // companion app.
        while app.staticTexts[testID.totalCost].label == "$0.00" {
            sleep(1)
        }
        print(app.debugDescription)
        XCTAssert(app.staticTexts[testID.totalCost].label == "$4.56")
        XCTAssert(app.staticTexts[testID.totalGallons].label == "1.030")
        XCTAssert(app.staticTexts[testID.totalMiles].label == "35")
        XCTAssert(app.staticTexts[testID.totalMPG].label == "34.0")
        XCTAssert(app.staticTexts[testID.totalCPG].label == "$4.43")
    }
}

// stackoverflow answer to the "can't tap" failure
extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate =
                self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
}
