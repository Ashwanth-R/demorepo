import SwiftUI

struct EditView: View {
    @State var name: String
    var onEdit: ((String) -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            TextField("Edit name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Save") {
                if !name.isEmpty {
                    onEdit?(name)
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(name: "Sample")
    }
}
