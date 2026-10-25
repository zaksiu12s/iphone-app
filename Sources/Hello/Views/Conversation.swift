import SwiftUI

struct Conversation: View {
    @ObservedObject var chatService: ChatService
    let isTextFieldFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(chatService.messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                }

                                MessageBubble(
                                    message: message,
                                    parentWidth: geometry.size.width
                                )

                                if !message.isUser {
                                    Spacer()
                                }
                            }
                            .id(message.id)
                        }

                        if chatService.isLoading {
                            HStack {
                                ProgressView()
                                Spacer()
                            }
                            .id("loading")
                        }
                    }
                    .frame(width: geometry.size.width)
                    .frame(
                        minHeight: geometry.size.height,
                        alignment: .top
                    )
                }
                .onChange(of: chatService.messages.count) {
                    scrollToLatest(using: proxy)
                }
                .onChange(of: chatService.isLoading) {
                    if chatService.isLoading {
                        scrollToLatest(using: proxy, id: "loading")
                    }
                }
                .onChange(of: isTextFieldFocused) {
                    guard isTextFieldFocused else {
                        return
                    }

                    Task { @MainActor in
                        await Task.yield()
                        scrollToLatest(using: proxy)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func scrollToLatest(
        using proxy: ScrollViewProxy,
        id: AnyHashable? = nil
    ) {
        let target = id ?? chatService.messages.last?.id

        guard let target else {
            return
        }

        withAnimation {
            proxy.scrollTo(target, anchor: .bottom)
        }
    }
}
