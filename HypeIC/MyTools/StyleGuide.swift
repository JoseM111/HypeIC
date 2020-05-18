import UIKit

extension UIView {
    
    // Corner radius
    func addCornerRadius(_ radius: CGFloat = 4) {
        self.layer.cornerRadius = radius
    }
    
    // Accent borders
    func addAccentBorder(_ width: CGFloat = 1, color: UIColor = .lightGray) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    // To rotate our buttons
    func rotate(by radians: CGFloat = (-CGFloat.pi / 2)) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
    
}

struct FontNames {
    static let latoBold = "Lato-Bold"
    static let latoRegular = "Lato-Regular"
    static let latoLight = "Lato-Light"
}

extension UIColor {
    static let greenAccent = UIColor(named: "greenAccent")!
    static let spaceGray = UIColor(named: "spaceGray")!
    static let borderHighLight = UIColor(named: "borderHighLight")!
    static let subtleText = UIColor(named: "subtleText")!
    static let mainText = UIColor(named: "mainText")!
    static let purpleAccent = UIColor(named: "purpleAccent")!
    static let cardGray = UIColor(named: "cardGray")!
    static let spaceBlack = UIColor(named: "spaceBlack")!
}
