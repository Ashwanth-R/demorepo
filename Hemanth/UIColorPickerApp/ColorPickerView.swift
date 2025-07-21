import SwiftUI

struct ColorPickerView: View {
    @State private var selectedColor: Color = .blue
    private let colors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink, .gray, .mint, .indigo, .brown]

    let columns = [GridItem(.adaptive(minimum: 50), spacing: 16)]

    var body: some View {
        VStack(spacing: 20) {
            Text("Selected Color")
                .font(.headline)
            Rectangle()
                .fill(selectedColor)
                .frame(height: 150)
                .cornerRadius(12)
                .shadow(radius: 5)
            Text("Pick a Color")
                .font(.subheadline)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(colors, id: \ .self) { color in
                    Button(action: {
                        selectedColor = color
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle().stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 3)
                            )
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView()
    }
}
