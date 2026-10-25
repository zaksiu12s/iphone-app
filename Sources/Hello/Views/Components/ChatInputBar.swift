import SwiftUI

struct ChatInputBar: View {
    @ObservedObject var viewService: ChatService
    @Binding var inputText: String
    @FocusState.Binding var isTextFieldFocused: Bool
    @Binding var isSidebarOpen: Bool

    var body: some View {
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
                .glassEffect(.regular.interactive(), in: Capsule())
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
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.plain)
            .background(.blue, in: Circle())
            .disabled(
                inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    || viewService.isLoading
            ).padding(.trailing, 8)
            .onChange(of: isTextFieldFocused) {
                if isTextFieldFocused {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        isSidebarOpen = false
                    }
                }
            }
            .frame(width: 40, height: 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
}
