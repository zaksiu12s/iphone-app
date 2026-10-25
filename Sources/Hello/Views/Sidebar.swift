import SwiftUI

struct Sidebar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("AI Chat App")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
        }.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(16)
            .frame(maxHeight: .infinity, alignment: .topLeading)
    }
}
