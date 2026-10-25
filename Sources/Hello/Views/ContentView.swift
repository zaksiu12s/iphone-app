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
        .safeAreaInset(edge: .bottom, spacing: 8) {
            ZStack(alignment: .trailing) {
                TextField("Enter your message...", text: $inputText)
                    .padding(.leading, 16)
                    .padding(.trailing, 56)
                    .frame(height: 52)
                    .focused($isTextFieldFocused)
                    .contentShape(Capsule())
                    .onTapGesture {
                        isTextFieldFocused = true
                    }
                    .glassEffect(.regular, in: Capsule())
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
                    Image(systemName: "arrow.up")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
                .background(.blue, in: Circle())
                .disabled(
                    inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        || viewService.isLoading
                ).padding(.trailing, 8)
                .frame(width: 40, height: 40)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
    }
}
