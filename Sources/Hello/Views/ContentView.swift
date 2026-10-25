import SwiftUI

struct ContentView: View {
    @StateObject private var viewService: ChatService = ChatService()
    @State private var inputText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var isSidebarOpen = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                HStack {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            isSidebarOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .padding(5)
                            .foregroundStyle(.white)
                    }.glassEffect(.regular.interactive(), in: Circle())

                    Spacer()
                }

                Conversation(chatService: viewService)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x: isSidebarOpen ? 250 : 0)
            .animation(
                .spring(response: 0.35, dampingFraction: 0.85),
                value: isSidebarOpen
            )
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

            if isSidebarOpen {
                Sidebar()
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }

            HStack {
                Color.clear
                    .frame(width: 100)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 20)
                            .onEnded { value in
                                if value.translation.width > 60 {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                        isSidebarOpen = true
                                    }
                                }
                            }
                    )

                Spacer(minLength: 0)
            }
            .allowsHitTesting(!isSidebarOpen)

            HStack {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 40)
                            .onEnded { value in
                                if value.translation.width < -60 {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                        isSidebarOpen = false
                                    }
                                }
                            }
                    )
            }.allowsHitTesting(isSidebarOpen)
        }
        .onChange(of: isSidebarOpen) {
            if isSidebarOpen {
                isTextFieldFocused = false
            }
        }
    }
}
