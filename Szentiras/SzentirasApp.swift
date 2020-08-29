//
//  SzentirasApp.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

@main
struct SzentirasApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
