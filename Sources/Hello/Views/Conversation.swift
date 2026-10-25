import SwiftUI

struct Conversation: View {
    let messages: [ChatMessage]

    var body: some View {
        GeometryReader {
            geometry in
            ScrollView {
                LazyVStack {
                    ForEach(messages) {
                        message in
                        HStack {
                            if message.isUser {
                                Spacer()
                            }

                            MessageBubble(message: message, parentWidth: geometry.size.width)

                            if !message.isUser {
                                Spacer()
                            }
                        }
                    }
                }.frame(width: geometry.size.width)
            }.defaultScrollAnchor(.bottom)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
