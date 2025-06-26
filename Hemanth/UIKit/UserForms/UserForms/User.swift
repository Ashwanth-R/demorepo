import Foundation

struct User {
    var id: UUID = UUID()
    let firstName: String
    let lastName: String
    let gender: String
    let email: String
    let phone: String
    let DOB: Date
    
}

class UsersViewModel {
    var users: [User] = []
    
    func addUser(_ user: User) {
        users.append(user)
    }
}
