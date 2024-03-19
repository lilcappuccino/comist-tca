//
//  QuestionDetailView.swift
//
//
//  Created by Vadim Marchenko on 18.03.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Domain

public struct QuestionDetailView: View {

    // MARK: - Properties
    @Bindable var store: StoreOf<QuestionDetail>

    init(store: StoreOf<QuestionDetail>) {
        self.store = store
    }

    // MARK: - Body
    public var body: some View {
        ZStack {
            if let question = store.question {
                content(question: question)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(CGSize(width: 2.0, height: 2.0))
                    .navigationBarTitle(store.title)
            }
        }
        .onAppear {
            store.send(.initialAction)
        }
        .navigationBarTitle(store.title)
        .toolbar {
            ToolbarItem(placement: .principal) {
                toolbar
                    .foregroundStyle(Color.background)
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
        .sheet(item: $store.scope(state: \.addArgument, action: \.addArgument)) { store in
            CreateArgumentView(store: store)
        }
    }

    @ViewBuilder
    var toolbar: some View {
        HStack {
            Spacer()
            Button(action: {
                store.send(.addArgumentTapped)
            }, label: {
                Image(systemName: "plus")
                    .font(.title2)
            })
        }
    }

    func content(question: Question) -> some View {
        VStack {
            if let subtitle = question.subtitle {
                Text(subtitle)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }

            Picker("",
                   selection:
                    .init(get: { store.selectedIndex },
                          set: { store.send(.segmentTapped($0))})
            ) {
                Text(prepareTitle(for: .pros))
                    .tag(0)
                Text(prepareTitle(for: .cons))
                    .tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            TabView(selection:
                    .init(get: { store.selectedIndex },
                          set: { store.send(.segmentTapped($0))})) {
                generateForm(sum: question.prosArgumentsValue,
                             arguments: question.prosArguments,
                             position: .pros)
                .tag(0)
                generateForm(sum: question.consArgumentsValue,
                             arguments: question.consArguments,
                             position: .cons)
                .tag(1)
            }
//                          .tabViewStyle(.page)
//                          .disabled(true)
        }
    }

    @ViewBuilder
    func generateForm(sum: Int, arguments: [QuestionArgument], position: ArgumentPosition) -> some View {
        Form {
            Section("SUM: \(sum)") {
                ForEach(arguments, id: \.id) { argument in
                    Text("\(argument.value) ∘ \(argument.title)")
                }
                .onDelete(perform: { indexSet in
                    store.send(.itemDeleted(indexSet))
                })
            }
        }
    }

    func prepareTitle(for position: ArgumentPosition) -> String {
        return "\(position.emoji) \(position.titleKey.localized)"
    }
}

#Preview {
    QuestionDetailView(store: Store(initialState: QuestionDetail.State(identifier: UUID())) {
        QuestionDetail()
    })
}
