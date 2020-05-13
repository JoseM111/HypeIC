import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: _@IBOutlet
    @IBOutlet weak var userNameTextField: UILabel!
    @IBOutlet weak var bioTextField: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
    }
    
    // MARK: _@IBAction
    @IBAction func signUpBtnTapped(_ sender: Any) {
        guard let username = userNameTextField.text, !username.isEmpty,
            let bio = bioTextField.text else { return }
        
        UserModelController.shared.createUser(username: username, bio: bio) { (result) in
            switch result {
                
                case .success(_):
                    self.presentHypeListVC()
                case .failure(let error):
                printf("\(error) -->> \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Helper Methods
    func fetchUser() {
        UserModelController.shared.fetchUser { [weak self] (success) in
            switch success {
                case .success(_):
                    self?.presentHypeListVC()
                case .failure(let error):
                    printf("\(error) -->> \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Helper Method
    func presentHypeListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeStoryboard", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
}// END OF CLASS
