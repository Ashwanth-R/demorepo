import UIKit

class FirstScreen: UIViewController {
    let tableView = UITableView()
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setTableViewDelegate()

        view.backgroundColor = .systemBackground
        title = "Users List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUserButton))
        
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegate()
        tableView.rowHeight = 100
        
        tableView.pin(to: view)
        
    }
    
    func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func addUserButton() {
        let nextScreen = SecondScreen()
        //print("Button Clicked")
        let navController = UINavigationController(rootViewController: nextScreen)
        navController.title = "Personal Information"
        //navigationController?.pushViewController(nextScreen, animated: true)
        self.present(navController, animated: true)
    }
    
}

extension FirstScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
}

extension UIView {
    func pin(to superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}

/*
 let nextButton = UIButton()
 
 override func viewDidLoad() {
     super.viewDidLoad()
     setupButton()
     view.backgroundColor = .systemBackground
     title = "First Screen"
     navigationController?.navigationBar.prefersLargeTitles = true
 }
 
 func setupButton() {
     view.addSubview(nextButton)
     
     nextButton.configuration = .filled()
     nextButton.configuration?.baseBackgroundColor = .systemPink
     nextButton.configuration?.title = "Next View"
     
     nextButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
     
     nextButton.translatesAutoresizingMaskIntoConstraints = false
     
     NSLayoutConstraint.activate([
         nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         nextButton.widthAnchor.constraint(equalToConstant: 200),
         nextButton.heightAnchor.constraint(equalToConstant: 50)
     ])
 }
 
 @objc func goToNextScreen() {
     let nextScreen = SecondScreen()
     nextScreen.title = "Second Screen"
     navigationController?.pushViewController(nextScreen, animated: true)
 }
 */
