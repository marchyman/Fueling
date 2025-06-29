//
// Copyright 2025 Marco S Hyman
// https://www.snafu.org/
//

import Foundation

enum TestIDs {
    enum ContentView {
        static let noContentID = "view.nocontent"
        static let editButtonID = "button.edit"
        static let addButtonID = "button.add"
        static let versionStringID = "statictext.version"

        static func vehicleButtonID(_ name: String) -> String {
            "button.vehicle \(name)"
        }
    }
}
