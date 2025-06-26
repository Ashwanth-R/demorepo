//
//  UserDetailViewController.swift
//  UserForms
//
//  Created by hemanth.p on 28/01/25.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            nameLabel.text = "\(user.firstName) \(user.lastName)"
            emailLabel.text = user.email
            phoneLabel.text = user.phone
            dobLabel.text = DateFormatter.localizedString(from: user.DOB, dateStyle: .medium, timeStyle: .none)
            genderLabel.text = user.gender
        }
    }

}
