//
//  CreateArgumentView.swift
//
//
//  Created by Vadim Marchenko on 18.03.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Domain

struct CreateArgumentView: View {

    // MARK: - Properties
    @Bindable var store: StoreOf<CreateArgument>

    var body: some View {
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
            TextField("input-arg-title".localized,
                      text: .init(get: { store.title },
                                  set: { store.send(.nameChanged($0))}
                                 ))
            .textFieldStyle(.roundedBorder)
            Picker("", selection:
                    .init(get: { store.position },
                          set: { store.send(.positionChanged($0))})) {
                Text(prepareTitle(for: .pros))
                    .tag(ArgumentPosition.pros)
                Text(prepareTitle(for: .cons))
                    .tag(ArgumentPosition.cons)
            }.pickerStyle(.segmented)
            Picker("", selection:
                    .init(get: { store.priority },
                          set: { store.send(.priorityChanged($0))})) {
                ForEach(FibonacciPriority.allCases, id: \.self) { priority in
                    Text("\(priority.title)")
                        .tag(priority())
                }
            }
                          .pickerStyle(.inline)
            Spacer()
        }.padding()
            .presentationDetents([.height(300)])
    }

    private func prepareTitle(for position: ArgumentPosition) -> String {
        return "\(position.emoji) \(position.titleKey.localized)"
    }
}

#Preview {
    CreateArgumentView(store: Store(initialState: CreateArgument.State(questionIdentifier: UUID())) {
        CreateArgument()
    })
}
