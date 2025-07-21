import SwiftUI

struct UserDataFormView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var phone: String = ""
    @State private var submitted: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }
                Button("Submit") {
                    submitted = true
                }
                .disabled(name.isEmpty || email.isEmpty || age.isEmpty || phone.isEmpty || !email.contains("@"))
            }
            .navigationTitle("User Data Form")
            .alert(isPresented: $submitted) {
                Alert(title: Text("Submitted!"), message: Text("Name: \(name)\nEmail: \(email)\nAge: \(age)\nPhone: \(phone)"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct UserDataFormView_Previews: PreviewProvider {
    static var previews: some View {
        UserDataFormView()
    }
}
