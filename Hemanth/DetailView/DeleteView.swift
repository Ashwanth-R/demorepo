import SwiftUI

struct DeleteView: View {
    var name: String
    var onDelete: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to delete \(name)?")
                .font(.headline)
                .padding()
            Button("Delete") {
                onDelete?()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteView(name: "Sample")
    }
}
