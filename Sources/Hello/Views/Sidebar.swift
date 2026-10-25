import SwiftUI

struct Sidebar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("AI Chat App")
                .font(.title2.bold())
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .glassEffect(
            .regular,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
    }
}
