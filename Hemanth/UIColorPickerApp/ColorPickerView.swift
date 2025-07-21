import SwiftUI

struct ColorPickerView: View {
    @State private var selectedColor: Color = .blue
    @State private var colors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink, .gray]

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
            WaterfallGrid(colors, id: \ .self) { color in
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
            .gridStyle(columns: 4, spacing: 16)
            .padding()
        }
        .padding()
    }
}

// Simple WaterfallGrid implementation for demonstration
struct WaterfallGrid<Data, Content>: View where Data: RandomAccessCollection, Content: View, Data.Element: Hashable {
    let data: Data
    let content: (Data.Element) -> Content
    var columns: Int = 2
    var spacing: CGFloat = 8

    init(_ data: Data, id: KeyPath<Data.Element, Data.Element>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    var body: some View {
        let rows = data.count / columns + (data.count % columns == 0 ? 0 : 1)
        return VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<rows, id: \ .self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<columns, id: \ .self) { column in
                        let index = row * columns + column
                        if index < data.count {
                            content(Array(data)[index])
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    func gridStyle(columns: Int, spacing: CGFloat) -> WaterfallGrid<Data, Content> {
        var copy = self
        copy.columns = columns
        copy.spacing = spacing
        return copy
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView()
    }
}
