import Foundation
import FoundationModels

@available(iOS 27.0, *)
@MainActor
class ChatService: ObservableObject {
    let session = LanguageModelSession()

    @Published var messages: [ChatMessage] = [
        ChatMessage(text: "Hello, how can I help you?", isUser: false)
    ]
    @Published var isLoading: Bool = false

    public func sendMessage(_ text: String) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isLoading = true

        let userMessage = ChatMessage(
            text: text.trimmingCharacters(in: .whitespacesAndNewlines), isUser: true)
        messages.append(userMessage)

        do {
            let aiResponse = try await fetchAIResponse(text)
            let aiMessage = ChatMessage(text: aiResponse, isUser: false)
            messages.append(aiMessage)
        } catch {
            let errorMessage = ChatMessage(
                text: "Error \(error.localizedDescription)", isUser: false)
            messages.append(errorMessage)
        }

        isLoading = false
    }

    private func fetchAIResponse(_ prompt: String) async throws -> String {
        let response = try await session.respond(to: prompt)

        return response.content
    }
}
