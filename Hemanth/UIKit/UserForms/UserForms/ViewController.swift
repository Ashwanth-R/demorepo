//
//  ViewController.swift
//  UserForms
//
//  Created by hemanth.p on 28/01/25.
//

import UIKit

class ViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    let viewModel = UsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
    }
    
    @IBAction func addUser(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addUserVC = storyboard.instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController {
            addUserVC.onSave = { [weak self] user in
                self?.viewModel.addUser(user)
                self?.tableView.reloadData()
                
                print("This: \(user.firstName)")
            }
            navigationController?.pushViewController(addUserVC, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = viewModel.users[indexPath.row]
        
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        return cell
    }
    
}

