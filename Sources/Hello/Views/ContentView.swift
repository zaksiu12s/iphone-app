import SwiftUI

struct ContentView: View {
    @StateObject private var viewService = ChatService()
    @State private var inputText = ""

    var body: some View {
        VStack {
            Header()

            Conversation(messages: viewService.messages)

            Spacer()

            HStack {
                TextField("Enter your message...", text: $inputText)
                    .padding()
                Button {
                    let prompt = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !prompt.isEmpty, !viewService.isLoading else {
                        return
                    }

                    Task {
                        inputText = ""
                        await viewService.sendMessage(prompt)
                    }
                } label: {
                    Text("Ask").bold()
                }
                .glassEffect()
                .disabled(
                    inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        || viewService.isLoading
                )
            }.glassEffect()
        }
        .padding().frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
