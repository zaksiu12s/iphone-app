import SwiftUI

struct ContentView: View {
    @State private var promptMessage: String = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hello, how can I help you?", isUser: false)
    ]

    var body: some View {
        VStack {
            Text("AI Chat").padding().font(.largeTitle)

            Conversation(messages: messages)

            Spacer()

            HStack {
                TextField("Enter your message...", text: $promptMessage)
                    .padding()
                Button {
                    messages.append(ChatMessage(text: promptMessage, isUser: true))
                    promptMessage = ""
                } label: {
                    Text("Ask").bold()
                }.glassEffect()
            }.glassEffect()
        }
        .padding().frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
