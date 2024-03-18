//
//  QuestionDetailView.swift
//
//
//  Created by Vadim Marchenko on 18.03.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct QuestionDetailView: View {
    
    // MARK: - Properties
    @Bindable var store: StoreOf<QuestionDetail>
    
    init(store: StoreOf<QuestionDetail>) {
        self.store = store
    }
    
    // MARK: - Body
    public var body: some View {
        Text("Test")
    }
}
