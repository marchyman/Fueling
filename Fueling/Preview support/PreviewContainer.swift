//
//  PreviewContainer.swift
//  Fueling
//
//  Created by Marco S Hyman on 8/7/23.
//

import Foundation
import SwiftData

let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Vehicle.self,
                                           ModelConfiguration(inMemory: true))
        Task { @MainActor in
            let context = container.mainContext
            
            let vehicle = Vehicle.sample()
            context.insert(vehicle)
        }
        return container
    } catch {
        fatalError("Failed to create container with error: \(error.localizedDescription)")
    }
}()
