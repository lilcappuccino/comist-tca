//
//  HomeView.swift
//
//
//  Created by Vadim Marchenko on 08.03.2024.
//

import SwiftUI
import ComposableArchitecture

public struct QuestionListView: View {
    
    @Bindable var store: StoreOf<QuestionList>
    
    public init(store: StoreOf<QuestionList>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
//            if store.questions.isEmpty {
            HStack {
                Text("Empry state")
            }
//            } else {
//                ScrollView {
//                    LazyVStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
//                        ForEach(1...10, id: \.self) { count in
//                            /*@START_MENU_TOKEN@*/Text("Placeholder \(count)")/*@END_MENU_TOKEN@*/
//                        }
//                    })
//                }
//                
//                //                .
//            }
        } 
        .onAppear {
            store.send(.initialAction)
        }
        .background(Color.background)
            .navigationTitle("title".localized)
            .toolbarBackground(Color.background, for: .navigationBar)
    }
    
}

#Preview {
    QuestionListView(store: Store(initialState: QuestionList.State()) {
        QuestionList()
    })
}
