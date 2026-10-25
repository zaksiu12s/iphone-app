import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        Text(message.text)
            .padding()
            .background(
                message.isUser
                    ? Color.blue.opacity(0.2)
                    : Color.gray.opacity(0.2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
