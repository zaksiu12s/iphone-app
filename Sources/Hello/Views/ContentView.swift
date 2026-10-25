import SwiftUI

struct ContentView: View {
    @StateObject private var viewService: ChatService = ChatService()
    @State private var inputText = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var isSidebarOpen = false

    var body: some View {
        VStack {
            Conversation(chatService: viewService)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            HStack {
                TextField("Enter your message...", text: $inputText)
                    .padding()
                    .focused($isTextFieldFocused)
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
                .glassEffect(.regular.interactive())
                .disabled(
                    inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        || viewService.isLoading
                )
            }
            .glassEffect(.regular.interactive())
            .padding(.horizontal)
        }
    }
}
