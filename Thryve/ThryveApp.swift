//
//  ThryveApp.swift
//  Thryve
//
//  Created by Praggnya Kanungo on 3/29/25.
//

import SwiftUI

@main
struct ThryveApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
