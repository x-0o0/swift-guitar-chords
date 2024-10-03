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
import Foundation
import CoreText

extension NSAttributedString {

    func computeLetterPaths(size: CGSize) -> (paths: [CGPath], positions: [CGPoint]) {
        var letterPaths: [CGPath] = []
        var lineRects: [CGRect] = []
        var letterPositions: [CGPoint] = []

        let frameSetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let textPath = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        let textFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, self.length), textPath, nil)

        let lines = CTFrameGetLines(textFrame)
        var origins = [CGPoint](repeating: .zero, count: CFArrayGetCount(lines))
        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), &origins)

        for lineIndex in 0..<CFArrayGetCount(lines) {
            let unmanagedLine: UnsafeRawPointer = CFArrayGetValueAtIndex(lines, lineIndex)
            let line: CTLine = unsafeBitCast(unmanagedLine, to: CTLine.self)
            var lineOrigin = origins[lineIndex]
            let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useGlyphPathBounds)
            lineRects.append(lineBounds)

            // adjust origin for flipped coordinate system
            lineOrigin.y = (lineBounds.height/3) - (size.height - lineOrigin.y)

            let runs = CTLineGetGlyphRuns(line)
            for runIndex in 0..<CFArrayGetCount(runs) {
                let runPointer = CFArrayGetValueAtIndex(runs, runIndex)
                let run = unsafeBitCast(runPointer, to: CTRun.self)
                let attribs = CTRunGetAttributes(run)
                let fontPointer = CFDictionaryGetValue(attribs, Unmanaged.passUnretained(kCTFontAttributeName).toOpaque())
                let font = unsafeBitCast(fontPointer, to: CTFont.self)

                let glyphCount = CTRunGetGlyphCount(run)
                var ascents = [CGFloat](repeating: 0, count: glyphCount)
                var descents = [CGFloat](repeating: 0, count: glyphCount)
                var leading = [CGFloat](repeating: 0, count: glyphCount)
                CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascents, &descents, &leading)

                for glyphIndex in 0..<glyphCount {
                    let glyphRange = CFRangeMake(glyphIndex, 1)
                    var glyph = CGGlyph()
                    var position = CGPoint.zero
                    CTRunGetGlyphs(run, glyphRange, &glyph)
                    CTRunGetPositions(run, glyphRange, &position)
                    position.y = lineOrigin.y

                    if let path = CTFontCreatePathForGlyph(font, glyph, nil) {
                        letterPaths.append(path)
                        letterPositions.append(position)
                    }
                }
            }
        }

        return (letterPaths, letterPositions)
    }

}
