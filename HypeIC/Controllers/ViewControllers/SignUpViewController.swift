import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: _@IBOutlet
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var welcomeToHypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var faqBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    // MARK: @Property
    var profilePhoto: UIImage?
    var viewsLayedOut: Bool = false
    
    
    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        setUpViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !viewsLayedOut {
            setUpViews()
            viewsLayedOut = true
        }
    }
    
    // MARK: _@IBAction
    @IBAction func loginBtnTapped(_ sender: Any) {
        toggleToLogIn()
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        toggleToSignUp()
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        guard UserModelController.shared.currentUser == nil else { self.presentHypeListVC(); return }
        guard let username = userNameTxtField.text, !username.isEmpty else { return }
        
        UserModelController.shared.createUser(username: username, profilePhoto: profilePhoto) { [weak self] (result) in
            switch result {
                
                case .success(_):
                    self?.presentHypeListVC()
                case .failure(let error):
                    printf("\(error) -->> \(error.localizedDescription)")
            }
        }
    }
    
    
    func setUpViews() {
        self.view.backgroundColor = .spaceGray
        photoContainerView.addCornerRadius(photoContainerView.frame.height / 2)
        photoContainerView.clipsToBounds = true
        
        signUpBtn.tintColor = .mainText
        loginBtn.tintColor = .subtleText
        helpBtn.setTitleColor(.mainText, for: .normal)
        faqBtn.setTitleColor(.greenAccent, for: .normal)
        loginBtn.rotate()
        signInBtn.rotate()
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
    
    func toggleToLogIn() {
        UIView.animate(withDuration: 0.2) {
            self.confirmTextField.isHidden = true
            self.loginBtn.tintColor = .mainText
            self.signUpBtn.tintColor = .subtleText
            self.signInBtn.setTitle("Log Me In!", for: .normal)
            self.helpBtn.setTitle("Forgot?", for: .normal)
            self.faqBtn.setTitle("Hint?", for: .normal)
            self.userNameTxtField.text = UserModelController.shared.currentUser?.username
        }
    }
    
    func toggleToSignUp() {
        UIView.animate(withDuration: 0.2) {
            self.signInBtn.tintColor = .mainText
            self.loginBtn.tintColor = .subtleText
            self.signInBtn.setTitle("Sign Me Up!", for: .normal)
            self.helpBtn.setTitle("Help", for: .normal)
            self.faqBtn.setTitle("FAQ", for: .normal)
            self.userNameTxtField.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            guard let destinationVC = segue.destination as? PhotoPickerViewController
                else { return }
            destinationVC.delegate = self
        }
    }
    
}// END OF CLASS

extension SignUpViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.profilePhoto = image
    }
    
    
}
