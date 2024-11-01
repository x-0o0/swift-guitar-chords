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

### Synchronizing

```swift
// Download json file to synchronize
try await GuitarChord.synchronize()
```
After retrieving the chords from the remote database, updates local storage.

### Searching Chords

```swift
// Case 1:
let chords = GuitarChord.search(named: "Am")

// Case 2:
let chords = GuitarChord.search(fretString: "0_1_0_2_3_0")
```

### Handling `Chord`

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

### AttributedString

`"{0_1_0_2_3_0-C}"` can be converted to `"C"` with url `"guitarchord://0_1_0_2_3_0"`.

```swift
let songMemo = """
{0_1_0_2_3_0-C}잔잔한 당신{0_0_1_2_2_0-E}은 {1_1_2_3_3_1-F}이 맘을 넘치{0_1_0_2_3_0-C}게 하지 않을거{0_1_0_2_0_0-Am7}야
그대로{1_1_2_3_3_1-F}도 편히 {2_1_2_0_x_x-D7}안길 수가 있으니{1_0_0_0_2_3-G7}까
"""

let convertedText = songMemo.convertSongMemo()

print(convertedText)
// """
// C잔잔한 당신E은 F이 맘을 넘치C게 하지 않을거Am7야
// 그대로F도 편히 D7안길 수가 있으니G7까
// """
```

## Managing Custom Chords

### Custom Scope Registration

```swift
GuitarChord.registerCustomScope(named: "user.created")

GuitarChord.unregisterCustomScope(named: "user.created")
```

### Fetching custom chords from the scope

```swift
let chords = GuitarChord.allChords(scopes: [.custom("user.created")])

let chords = GuitarChord.search(named: "Am", scopes: [.custom("user.created")])

let chords = GuitarChord.search(fretString: "0_1_0_2_3_0", scopes: [.custom("user.created")])
```

### Update scope with a custom chord

```swift
try GuitarChord.addChord(rawText: "myown-0_0_0_0_0_0",  to: .custom("user.created"))

try GuitarChord.deleteChord(byID: "0_0_10_10_8_x", from: .custom("user.created"))
```

## Used Opened Sources 

### Swifty Chords
The below files use [Swifty Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords) sources.
- [Chord.CAShapeLayer.swift](/Sources/GuitarChords/UI/Chord.CAShapeLayer.swift)
- [LineConfig.swift](/Sources/GuitarChords/UI/LineConfig.swift)
- [NSAttributedString.Extensions](/Sources/GuitarChords/Extensions/NSAttributedString.Extensions)
- [String.Extensions](/Sources/GuitarChords/Extensions/String.Extensions)
