import SwiftUI

struct AddView: View {
    @State private var name = ""
    var onAdd: ((String) -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Add") {
                if !name.isEmpty {
                    onAdd?(name)
                    name = ""
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
