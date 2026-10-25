import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    let parentWidth: CGFloat

    var body: some View {
        Text(message.text)
            .padding()
            .background(
                message.isUser
                    ? Color.blue.opacity(0.2)
                    : Color.gray.opacity(0.2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .fixedSize(
                horizontal: false, vertical: true
            ).frame(maxWidth: parentWidth * 0.75, alignment: message.isUser ? .trailing : .leading)

    }
}
