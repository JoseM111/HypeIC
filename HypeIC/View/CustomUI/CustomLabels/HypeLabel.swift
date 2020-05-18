import UIKit

class HypeLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(font: FontNames.latoRegular)
        self.textColor = .mainText
    }

    func updateFontTo(font: String) {
        let size = self.font.pointSize
        self.font = UIFont(name: font, size: size)!
    }
}

class HypeLabelLight: HypeLabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(font: FontNames.latoLight)
        self.textColor = .subtleText
    }
}

class HypeLabelBold: HypeLabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(font: FontNames.latoBold)
    }
}
