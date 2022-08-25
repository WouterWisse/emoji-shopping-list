import UIKit

extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}
