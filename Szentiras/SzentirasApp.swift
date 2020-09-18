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
    let store = BibliaStore(context: PersistenceController.shared.container.viewContext)
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(store)
        }
    }
}
