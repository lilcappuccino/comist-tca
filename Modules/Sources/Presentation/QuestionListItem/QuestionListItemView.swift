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
            if let emojiView = emojiView(for: item.position) {
                emojiView
                    .padding(.trailing, 4)
            }
            Text(item.title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.vertical, 8)
    }

    private func emojiView(for position: QuestionPositionModel) -> Text? {
        if item.position != QuestionPositionModel.unowned {
            return Text("\(position.emoji)")
        }
        return nil
    }
}

#Preview {
    QuestionListItemView(item: QuestionListModel(identifier: UUID(),
                                                 title: "Test",
                                                 position: .pros))
}
