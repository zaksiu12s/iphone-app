import SwiftUI

struct Conversation: View {
    let messages: [ChatMessage]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(messages, id: \.id) {
                    message in
                    HStack {
                        message.isUser ? Spacer() : nil
                        MessageBubble(message: message)
                        message.isUser ? nil : Spacer()
                    }
                }
            }
        }.defaultScrollAnchor(.bottom)
    }
}
