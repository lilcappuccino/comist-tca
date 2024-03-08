//
//  ComistApp.swift
//  Comist
//
//  Created by Vadim Marchenko on 08.03.2024.
//

import SwiftUI

@main
struct ComistApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
