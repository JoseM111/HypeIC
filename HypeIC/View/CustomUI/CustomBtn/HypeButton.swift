import UIKit

class HypeButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupViews() {
        updateFontTo(font: FontNames.latoRegular)
        self.backgroundColor = .greenAccent
        self.setTitleColor(.mainText, for: .normal)
        self.addCornerRadius()
    }
    
    // Function to update fonts
    func updateFontTo(font: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: font, size: size)!
    }

}
