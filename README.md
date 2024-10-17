# Guitar Chords

| Light Mode | Dark Mode |
| --- | --- |
| ![1](https://github-production-user-asset-6210df.s3.amazonaws.com/53814741/372998579-076f331a-9df6-4193-b433-83354c659efd.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20241017%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241017T153741Z&X-Amz-Expires=300&X-Amz-Signature=8922ae8301f2f54f8b5ebd1e5c31383f457521571effb2ddde70aec39537576d&X-Amz-SignedHeaders=host) | ![2](https://github-production-user-asset-6210df.s3.amazonaws.com/53814741/372998631-7632ffab-87d8-4606-87b4-ffdb5f3e4288.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20241017%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241017T154007Z&X-Amz-Expires=300&X-Amz-Signature=d540d60efa95bfe6e9b9ca2111c0f02619ce6e242d5830cd0de5602df6801cc2&X-Amz-SignedHeaders=host) |

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
let c코드 = Chord(name: "C", fretString: "0_1_0_2_3_0")

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
