//
//  HomeView.swift
//
//
//  Created by Vadim Marchenko on 08.03.2024.
//

import SwiftUI
import ComposableArchitecture

public struct QuestionListView: View {

    // MARK: - Properties
    @Bindable var store: StoreOf<QuestionList>

    // MARK: - Init
    public init(store: StoreOf<QuestionList>) {
        self.store = store
    }

    // MARK: - Body
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ZStack {
                emptyState
                content
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    toolbar
                        .foregroundStyle(.purple)
                }
            }
            .onAppear {
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.purple
                store.send(.didAppear)
            }
        } destination: { store in
            switch store.state {
            case .detail:
                if let store = store.scope(state: \.detail, action: \.openDetail) {
                    QuestionDetailView(store: store)
                }
            }
        }
        .sheet(
            item: $store.scope(state: \.addQuestion, action: \.addQuestion)
        ) { store in
          CreateQuestionView(store: store)
        }
        .tint(Color.background)
    }

    // MARK: Toolbar
    @ViewBuilder
    var toolbar: some View {
        HStack {
            Text("title".localized)
                .font(.largeTitle)
            Spacer()
            Button(action: {
                store.send(.addQuestionTapped)
            }, label: {
                Image(systemName: "plus")
                    .font(.title2)
            })
        }
        .foregroundStyle(Color.background)
    }

    // MARK: Empty State
    @ViewBuilder
    var emptyState: some View {
        VStack {
            Image(systemName: "tortoise.fill")
                .font(.largeTitle)
                .padding()
            Text("home-empty-state".localized)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }.padding(.bottom, 72)
            .foregroundStyle(Color.background)
            .padding()
    }

    // MARK: - Content
    @ViewBuilder
    var content: some View {
        Form {
            ForEach(store.questions, id: \.identifier) { item in
                QuestionListItemView(item: item)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.openItemTapped(item))
                    }
            }
            .onDelete(perform: { indexSet in
                store.send(.itemDeleted(indexSet))
            })
        }
        .opacity(store.questions.isEmpty ? 0 : 1)
    }
}

#Preview {
    QuestionListView(store: Store(initialState: QuestionList.State()) {
        QuestionList()
    })
}
