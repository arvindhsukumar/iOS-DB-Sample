//
//  DB_SampleApp.swift
//  DB Sample
//
//  Created by Arvindh Sukumar on 17/07/23.
//

import SwiftUI

//@main
//struct DB_SampleApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//          NavigationStack {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//          }
//        }
//    }
//}

@main
struct DB_SampleApp: App {
    let persistenceController = MainStore.instance

    var body: some Scene {
        WindowGroup {
          TabView {
            NavigationStack {
              R_D_Main_ListView()
            }
            .tabItem {
              Text("CoreData")
            }
            
            NavigationStack {
              RealmListView()
            }
            .tabItem {
              Text("Realm")
            }
          }
          .onAppear {
            MainStore.instance
            RealmStore.instance
            DBManager.shared.defaultDB = CD_DBManager()
          }
            
        }
    }
}
