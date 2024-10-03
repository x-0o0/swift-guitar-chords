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

extension Chord {
    func layer(rect: CGRect, primaryColor: UIColor) -> CAShapeLayer {
        let widthMultiplier = 1.2
        let horScale = rect.width / widthMultiplier
        let scale = min(horScale, rect.height)
        let newWidth = scale * widthMultiplier
        let size = CGSize(width: newWidth, height: scale)
        
        let stringMargin = size.height / 10
        let fretMargin = size.width / 10
        
        let fretLength = size.height - (stringMargin * 2)
        let stringLength = size.width - (fretMargin * 2)
        let origin = CGPoint(x: 1.2, y: rect.origin.y + fretMargin * 0.8)

        let fretSpacing = stringLength / CGFloat(self.numberOfFrets) // numberOfFrets
        let stringSpacing = fretLength / CGFloat(5) // numberOfStrings - 1
        
        let fretConfig = LineConfig(spacing: fretSpacing, margin: fretMargin, length: fretLength, count: 4)
        let stringConfig = LineConfig(spacing: stringSpacing, margin: stringMargin, length: stringLength, count: 5)

        let layer = CAShapeLayer()
        
        let stringsAndFrets = stringsAndFretsLayer(fretConfig: fretConfig, stringConfig: stringConfig, origin: origin, primaryColor: primaryColor)
        let dots = dotsLayer(stringConfig: stringConfig, fretConfig: fretConfig, origin: origin, rect: rect, primaryColor: primaryColor)
        
        layer.addSublayer(stringsAndFrets)
        layer.addSublayer(dots)
        
        layer.frame = CGRect(x: 0, y: 0, width: newWidth, height: newWidth)

        return layer
    }
    
    private func stringsAndFretsLayer(fretConfig: LineConfig, stringConfig: LineConfig, origin: CGPoint, primaryColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()

        let primaryColor = primaryColor.cgColor

        // Strings
        let stringPath = CGMutablePath()

        for string in 0...stringConfig.count {
            let y = stringConfig.spacing * CGFloat(string) + stringConfig.margin + origin.y
            stringPath.move(to: CGPoint(x: fretConfig.margin + origin.x, y: y))
            stringPath.addLine(to: CGPoint(x: stringConfig.length + fretConfig.margin + origin.x, y: y))
        }

        let stringLayer = CAShapeLayer()
        stringLayer.path = stringPath
        stringLayer.lineWidth = stringConfig.spacing / 24
        stringLayer.strokeColor = primaryColor
        layer.addSublayer(stringLayer)

        // Frets
        let fretLayer = CAShapeLayer()

        for fret in 0...fretConfig.count {
            let fretPath = CGMutablePath()
            let lineWidth: CGFloat

            if self.baseFret == 1 && fret == 0 {
                lineWidth = fretConfig.spacing / 5
            } else {
                lineWidth = fretConfig.spacing / 24
            }

            // Draw fret number
            if self.baseFret > 1 {
                let txtLayer = CAShapeLayer()
                let txtFont = UIFont.systemFont(ofSize: fretConfig.margin * 0.8)
                let txtRect = CGRect(x: 0, y: 0, width: fretConfig.spacing, height: fretConfig.margin)
                let transX = origin.x + (stringConfig.spacing / 2) + stringConfig.margin
                let transY = fretConfig.margin / 5 + origin.y
                let txtPath = "\(self.baseFret)".path(font: txtFont, rect: txtRect, position: CGPoint(x: transX, y: transY))
                txtLayer.path = txtPath
                txtLayer.fillColor = primaryColor
                fretLayer.addSublayer(txtLayer)
            }

            let x = fretConfig.spacing * CGFloat(fret) + fretConfig.margin + origin.x
            let y = origin.y + stringConfig.margin
            fretPath.move(to: CGPoint(x: x, y: y))
            fretPath.addLine(to: CGPoint(x: x, y: fretConfig.length + y))

            let fret = CAShapeLayer()
            fret.path = fretPath
            fret.lineWidth = lineWidth
            fret.lineCap = .square
            fret.strokeColor = primaryColor
            fretLayer.addSublayer(fret)
        }

        layer.addSublayer(fretLayer)

        return layer
    }
    
    private func dotsLayer(stringConfig: LineConfig, fretConfig: LineConfig, origin: CGPoint, rect: CGRect, primaryColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()

        let primaryColor = primaryColor.cgColor
        let backgroundColor = UIColor.clear.cgColor

        for index in 0..<self.frets.count {
            let fret = self.frets[index]

            // Draw circle above nut ⭕️
            if fret == 0 {
                let size = fretConfig.spacing * 0.33
                let circleX = fretConfig.margin - size * 1.6 + origin.x
                let circleY = ((CGFloat(index) * stringConfig.spacing + stringConfig.margin) - size / 2 + origin.y)
                let center = CGPoint(x: circleX, y: circleY)
                let frame = CGRect(origin: center, size: CGSize(width: size, height: size))

                let circle = CGMutablePath(roundedRect: frame, cornerWidth: frame.width/2, cornerHeight: frame.height/2, transform: nil)

                let circleLayer = CAShapeLayer()
                circleLayer.path = circle
                circleLayer.lineWidth = fretConfig.spacing / 24
                circleLayer.strokeColor = primaryColor
                circleLayer.fillColor = backgroundColor

                layer.addSublayer(circleLayer)

                continue
            }

            // Draw cross above nut ❌
            if fret == -1 {
                let size = fretConfig.spacing * 0.33
                let crossX = fretConfig.margin - size * 1.6 + origin.x
                let crossY = ((CGFloat(index) * stringConfig.spacing + stringConfig.margin) - size / 2 + origin.y)
                
                let center = CGPoint(x: crossX, y: crossY)
                let frame = CGRect(origin: center, size: CGSize(width: size, height: size))
                
                let cross = CGMutablePath()
                
                cross.move(to: CGPoint(x: frame.minX, y: frame.minY))
                cross.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
                
                cross.move(to: CGPoint(x: frame.minX, y: frame.maxY))
                cross.addLine(to: CGPoint(x: frame.maxX, y: frame.minY))
                
                let crossLayer = CAShapeLayer()
                crossLayer.path = cross
                crossLayer.lineWidth = fretConfig.spacing / 24
                
                crossLayer.strokeColor = primaryColor
                
                layer.addSublayer(crossLayer)
                
                continue
            }

            let dotX = CGFloat(fret - self.baseFret + 1) * fretConfig.spacing + fretConfig.margin - (fretConfig.spacing / 2) + origin.x
            let dotY = (CGFloat(index) * stringConfig.spacing + stringConfig.margin + origin.y)

            let dotPath = CGMutablePath()
            dotPath.addArc(center: CGPoint(x: dotX, y: dotY), radius: fretConfig.spacing * 0.3, startAngle: 0, endAngle: .pi * 2, clockwise: true)

            let dotLayer = CAShapeLayer()
            dotLayer.path = dotPath
            dotLayer.fillColor = primaryColor

            layer.addSublayer(dotLayer)
        }

        return layer
    }
}

