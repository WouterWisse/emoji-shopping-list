import UIKit

extension UIColor {
    func adjustBrightness(by brightness: CGFloat = 0) -> UIColor {
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0
        
        if getHue(
            &currentHue,
            saturation: &currentSaturation,
            brightness: &currentBrigthness,
            alpha: &currentAlpha
        ) {
            return UIColor(
                hue: currentHue,
                saturation: currentSaturation,
                brightness: currentBrigthness + brightness,
                alpha: 1.0
            )
        } else {
            return self
        }
    }
}
