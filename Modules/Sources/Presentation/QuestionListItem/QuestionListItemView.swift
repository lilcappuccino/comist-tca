//
//  ProblemsListItemView..swift
//
//
//  Created by Vadim Marchenko on 11.03.2024.
//

import SwiftUI

struct QuestionListItemView: View {
    
    // MARK: - Properies
    let item: QuestionListModel
    
    // MARK: - Body
    var body: some View {
        HStack {
            if let emojiView = emojiView(for: item.state) {
                emojiView
                    .padding(.trailing, 4)
            }
            Text(item.title)
        }.padding(.vertical, 8)
    }
    
    private func emojiView(for state: QuestionStateModel) -> Text? {
        if item.state == QuestionStateModel.cons {
            return Text("🔴")
        } else if item.state == QuestionStateModel.pros {
            return Text("🟢")
        }
        return nil
    }
}

#Preview {
    QuestionListItemView(item: QuestionListModel(identifier: UUID(),
                                                 title: "Test",
                                                 state: .pros))
}
