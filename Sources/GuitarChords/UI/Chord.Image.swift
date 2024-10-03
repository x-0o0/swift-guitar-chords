/**
 - Note: See the `License.txt` file for this licensing information.
 */

import UIKit
import SwiftUI

extension Chord {
    public func image(rect: CGRect, primaryColor: UIColor = UIColor.label) -> Image? {
        let layer = self.layer(rect: rect, primaryColor: primaryColor)
        let uiImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)

        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: context)
        uiImage = UIGraphicsGetImageFromCurrentImageContext()
        guard let uiImage else { return nil }
        return Image(uiImage: uiImage)
    }
}
