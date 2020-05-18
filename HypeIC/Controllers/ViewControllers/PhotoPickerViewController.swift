import UIKit

// MARK: _@protocol
/**©---------------------------------------------©*/
protocol PhotoPickerDelegate: class {
    func photoPickerSelected(image: UIImage)
}
/**©---------------------------------------------©*/

class PhotoPickerViewController: UIViewController {
    // MARK: _@IBOutlet
    @IBOutlet weak var photoPickerImageView: UIImageView!
    @IBOutlet weak var selectPhotoBtn: UIButton!
    
    // MARK: @Properties
    var imagePicker = UIImagePickerController()
    weak var delegate: PhotoPickerDelegate?
    
    // MARK: _@ILife-Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    // MARK: _@IBAction
    @IBAction func selectPhotoBtnTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
        self.openCamera()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        
        let photoLibAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openPhotoLib()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Helper Methods
    func setupViews() {
        imagePicker.delegate = self
        photoPickerImageView.backgroundColor = .systemTeal
    }
    
    func presentFailedAlert(title: String, msg: String) {
        let failedAlert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        failedAlert.addAction(okAction)
        
        self.present(failedAlert, animated: true)
    }
    
}

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true)
        } else {
            self.presentFailedAlert(title: "No Camera Access", msg: "Please allow access to the camera")
        }
    }// END OF FUNC
    
    func openPhotoLib() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        } else {
            self.presentFailedAlert(title: "No photo library", msg: "Please allows us to access your photo library")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let delegate = delegate else { return }
            delegate.photoPickerSelected(image: pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
