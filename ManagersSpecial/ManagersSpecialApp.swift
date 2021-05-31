//
//  ManagersSpecialApp.swift
//  ManagersSpecial
//
//  Created by Todd Thomas on 5/24/21.
//

import SwiftUI

@main
struct ManagersSpecialApp: App {
  @ObservedObject private var store = Store()
  
  var body: some Scene {
    WindowGroup {
      SpecialsView(store: store)
        .onAppear {
          store.update()
        }
    }
  }
}
