//
//  CreateQuestionView.swift
//
//
//  Created by Vadim Marchenko on 19.03.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct CreateQuestionView: View {

    // MARK: - Properties
    @Bindable var store: StoreOf<CreateQuestion>

    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    store.send(.saveTapped)
                }, label: {
                    Text("save".localized)
                        .foregroundStyle(Color.background)
                        .font(.title3)
                        .opacity(store.title.isEmpty ? 0 : 1)
                        .animation(.easeIn, value: store.title)
                })
                .padding()
            }
            TextField("input-title".localized,
                      text: .init(get: { store.title  },
                                  set: { store.send(.titleChanged($0))}
                                 ))
            .textFieldStyle(.roundedBorder)
            .font(.title)
            .textFieldStyle(.roundedBorder)
            TextField("input-subtitle".localized,
                      text: .init(get: { store.subtitle },
                                  set: { store.send(.subtitle($0)) }
                                 ))
            Spacer()
        }.padding()
            .presentationDetents([.height(150)])
    }
}

#Preview {
    CreateQuestionView(store: Store(initialState: CreateQuestion.State()) {
        CreateQuestion()
    })
}
