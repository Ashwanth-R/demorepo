//
//  UserListViewController.swift
//  UserForms
//
//  Created by hemanth.p on 28/01/25.
//

import UIKit

class UserListViewController: UITableViewController {
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        tableView.dataSource = self
    }
    
    @objc func addUser() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addUserVC = storyboard.instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController {
            addUserVC.onSave = { [weak self] newUser in
                guard let self = self else { return }
                self.users.append(newUser)
                self.tableView.reloadData()
                //print("New User: \(users)")
            }
            navigationController?.pushViewController(addUserVC, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(users.count)
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        //print("User: \(user)")
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        //print("Test: \(cell.textLabel!.text ?? "Nah")")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetailSegue" {
            if let detailVC = segue.destination as? UserDetailViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedUser = users[indexPath.row]
                detailVC.user = selectedUser
            }
        }
    }
}
