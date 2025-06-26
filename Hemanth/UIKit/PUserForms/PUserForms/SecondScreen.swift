import UIKit

class SecondScreen: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    
    let firstNameField = UITextField()
    let lastNameField = UITextField()
    let emailField = UITextField()
    let phoneField = UITextField()
    
    let dobPicker = UIDatePicker()
    let genderPicker = UIPickerView()
    let genderOptions = ["Male", "Female", "Other", "Prefer not to say"]
    
    let submitButton = UIButton()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setNavBar()
        configureView()
        setupConstraints()
    }
    
    func setNavBar() {
        title = "Personal Information"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelScene))
    }
    
    func configureView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        print("View getting added")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        //Stack View
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        //Input Fields
        configureTextField(firstNameField, placeholder: "First Name")
        configureTextField(lastNameField, placeholder: "Last Name")
        configureTextField(emailField, placeholder: "Email")
        configureTextField(phoneField, placeholder: "Phone")
        
        dobPicker.datePickerMode = .date
        dobPicker.preferredDatePickerStyle = .wheels
        dobPicker.translatesAutoresizingMaskIntoConstraints = false
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.translatesAutoresizingMaskIntoConstraints = false
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitUserDetails), for: .touchUpInside)
        
        stackView.addArrangedSubview(firstNameField)
        stackView.addArrangedSubview(lastNameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(phoneField)
        stackView.addArrangedSubview(dobPicker)
        stackView.addArrangedSubview(genderPicker)
        stackView.addArrangedSubview(submitButton)
        
    }
    
    func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            submitButton.heightAnchor.constraint(equalToConstant: 50)
            
            
        ])
    }
    
    @objc func submitUserDetails() {
        print("Details collected")
        dismiss(animated: true)
    }
    
    @objc func cancelScene() {
        dismiss(animated: true)
    }
}

extension SecondScreen: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
}
