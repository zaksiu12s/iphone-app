import SwiftUI

struct Conversation: View {
    @ObservedObject var chatService: ChatService

    var body: some View {
        GeometryReader {
            geometry in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(chatService.messages) {
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

                    Spacer()

                    if chatService.isLoading {
                        HStack {
                            ProgressView()
                            Spacer()
                        }
                    }
                .frame(
                    width: geometry.size.width,
                    minHeight: geometry.size.height,
                    alignment: .top
                )
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
