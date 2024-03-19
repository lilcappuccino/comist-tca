//
//  ComistApp.swift
//  Comist
//
//  Created by Vadim Marchenko on 08.03.2024.
//

import SwiftUI
import Presentation
import ComposableArchitecture

@main
struct ComistApp: App {

    var body: some Scene {
        WindowGroup {
            QuestionListView(store: Store(initialState: QuestionList.State()) {
                QuestionList()._printChanges()
            })
        }
    }
}
