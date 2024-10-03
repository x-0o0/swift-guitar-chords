/**
 MIT License

 Copyright (c) 2020 Beau Nouvelle

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */
import UIKit

extension String {
    func path(font: UIFont, rect: CGRect, alignment: NSTextAlignment = .left, position: CGPoint) -> CGPath {

        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = alignment

        let paragraph = NSAttributedString(string: self, attributes: [.font: font, .paragraphStyle: titleParagraphStyle])

        let glyphPaths = paragraph.computeLetterPaths(size: rect.size)
        let titlePath = CGMutablePath()

        for (index, path) in glyphPaths.paths.enumerated() {
            let pos = glyphPaths.positions[index]
            titlePath.addPath(path, transform: CGAffineTransform(translationX: pos.x, y: pos.y))
        }

        var scale = CGAffineTransform(scaleX: 1, y: -1)
        var move = CGAffineTransform(translationX: position.x - titlePath.boundingBoxOfPath.midX, y: position.y - (titlePath.boundingBoxOfPath.height/2))

        return titlePath.copy(using: &scale)?.copy(using: &move) ?? CGMutablePath()
    }
}

