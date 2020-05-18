import UIKit

class HypeTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    func setupViews() {
        self.addCornerRadius(10)
        self.addAccentBorder()// Using Default
        self.setUpPlaceholderText()
        self.updateFontTo(font: FontNames.latoRegular)
        self.textColor = .mainText
        self.tintColor = .mainText
        self.backgroundColor = .spaceBlack
        self.layer.masksToBounds = true
    }
    
    // Function to update fonts
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: font, size: size)!
    }
    
    // PlaceHolder text
    func setUpPlaceholderText() {
        let currentPlaceholder = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.subtleText,
            NSAttributedString.Key.font: UIFont(name: FontNames.latoLight, size: 16)!
        ])
    }

}
