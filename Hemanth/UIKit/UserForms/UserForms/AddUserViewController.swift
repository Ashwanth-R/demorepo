//
//  AddUserViewController.swift
//  UserForms
//
//  Created by hemanth.p on 28/01/25.
//

import UIKit

class AddUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var gender: UIPickerView!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    
    let genderOptions = ["Male", "Female", "Other", "Prefer not to say"]
    var selectedGender: String = "Other"
    
    //var ViewModel: UsersViewModel?
    var onSave: ((User) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gender.delegate = self
        gender.dataSource = self
        
    }
    
    @IBAction func saveUser(_ sender: Any) {
        guard let firstName = firstName.text,
              let lastName = lastName.text,
              let email = emailID.text,
              let phone = phone.text else {return}
        let newUser = User(firstName: firstName, lastName: lastName, gender: selectedGender, email: email, phone: phone, DOB: birthDate.date)
        
        onSave?(newUser)
        
        navigationController?.popViewController(animated: true)
        //print(newUser.gender)
    }
    @IBAction func populate(_ sender: Any) {
        firstName.text = "Hemanth"
        lastName.text = "Palani"
        emailID.text = "hemanthpalani001@gmail.com"
        phone.text = "9150998077"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderOptions[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
