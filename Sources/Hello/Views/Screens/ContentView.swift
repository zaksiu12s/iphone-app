import SwiftUI

struct ContentView: View {
    @StateObject private var viewService: ChatService = ChatService()
    @State private var inputText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var isSidebarOpen = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 8) {
                HStack {
                    Button {
                        isTextFieldFocused = false

                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            isSidebarOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive(), in: Circle())
                    .padding(.top, 0)
                    .padding(.leading, 4)

                    Spacer()
                }

                Conversation(chatService: viewService)
            }.padding(.horizontal, 12)
                .padding(.bottom, 8)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: isSidebarOpen ? 250 : 0)
                .animation(
                    .spring(response: 0.35, dampingFraction: 0.85),
                    value: isSidebarOpen
                )
                .safeAreaInset(edge: .bottom, spacing: 8) {
                    ChatInputBar(
                        viewService: viewService,
                        inputText: $inputText,
                        isTextFieldFocused: $isTextFieldFocused,
                        isSidebarOpen: $isSidebarOpen
                    )
                }

            if isSidebarOpen {
                Sidebar()
                    .frame(width: 250)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 80)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .onChange(of: isSidebarOpen) {
            if isSidebarOpen {
                isTextFieldFocused = false
            }
        }.simultaneousGesture(
            DragGesture(minimumDistance: 25)
                .onEnded { value in
                    let dx = value.translation.width
                    let dy = value.translation.height

                    guard abs(dx) > abs(dy), abs(dx) > 60 else {
                        return
                    }

                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        if dx > 0 {
                            isSidebarOpen = true
                        } else {
                            isSidebarOpen = false
                        }
                    }
                }
        )
    }
}
