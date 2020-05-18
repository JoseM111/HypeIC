//
//  HypePhotoViewController.swift
//  HypeIC
//
//  Created by Jose Martinez on 5/14/20.
//  Copyright © 2020 Jose Martinez. All rights reserved.
//

import UIKit

class HypePhotoViewController: UIViewController {
    // MARK: _@IBOutlet
    @IBOutlet weak var hypeTextField: UITextField!
    @IBOutlet weak var photoContainerView: UIView!
    
    
    // MARK: @Properties
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: _@IBAction
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        guard let text = hypeTextField.text, !text.isEmpty,
            let image = image else { return }
        
        HypeModelController.shared.saveHype(with: text, hypePhoto: image) { (result) in
            switch result {
                case .success(_):
                    self.dismissView()
                case .failure(let error):
                    printf(error)
            }
        }
    }
    
    func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPicker" {
            guard let destinationVC = segue.destination as? PhotoPickerViewController else { return }
            destinationVC.delegate = self
        }
    }
}
extension HypePhotoViewController: PhotoPickerDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
    
    
}
