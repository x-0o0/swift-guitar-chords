# Guitar Chords

| Light Mode | Dark Mode |
| --- | --- |
| ![1](https://github.com/user-attachments/assets/076f331a-9df6-4193-b433-83354c659efd) | ![2](https://github.com/user-attachments/assets/7632ffab-87d8-4606-87b4-ffdb5f3e4288) |

## Overview

This package provides the models and the diagram images for guitar chords.

## Requirements
- Swift 6.0 + (Xcode 16.0+)
- iOS 16+

## How to Start

```swift
import GuitarChords
```

```swift
let c코드 = Chord(name: "C", fingering: "010230")

var body: some View {
  VStack {
    if let image = c코드.image(rect: rect) {
      image
    }
    Text(c코드.name)
  }
}
```

## Used Opened Sources 

### Swifty Chords
The below files use [Swifty Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords) sources.
- [Chord.CAShapeLayer.swift](/Sources/GuitarChords/UI/Chord.CAShapeLayer.swift)
- [LineConfig.swift](/Sources/GuitarChords/UI/LineConfig.swift)
- [NSAttributedString.Extensions](/Sources/GuitarChords/Extensions/NSAttributedString.Extensions)
- [String.Extensions](/Sources/GuitarChords/Extensions/String.Extensions)
