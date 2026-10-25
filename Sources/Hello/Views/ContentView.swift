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
                    if inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        return
                    }

                    Task {
                        do {
                            let prompt: String = inputText
                            inputText = ""
                            try await viewService.sendMessage(prompt)
                        } catch {
                            print("Error sending message: \(error)")
                        }
                    }
                } label: {
                    Text("Ask").bold()
                }
                .glassEffect()
                .disabled(inputText.isEmpty)
            }.glassEffect()
        }
        .padding().frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
