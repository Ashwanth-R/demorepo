import SwiftUI

struct ViewDetail: View {
    var name: String
    var email: String
    var age: String
    var phone: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Name: \(name)")
            Text("Email: \(email)")
            Text("Age: \(age)")
            Text("Phone: \(phone)")
        }
        .padding()
        .navigationTitle("View Details")
    }
}

struct ViewDetail_Previews: PreviewProvider {
    static var previews: some View {
        ViewDetail(name: "John Doe", email: "john@example.com", age: "30", phone: "1234567890")
    }
}
