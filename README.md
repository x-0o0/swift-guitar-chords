# Guitar Chords

<img width="942" alt="스크린샷 2024-11-02 오전 1 59 48" src="https://github.com/user-attachments/assets/bf712ea7-7f85-4291-8dfd-52b103aff5d2">

## Overview

This package provides the models and the diagram images for guitar chords.

## Requirements
- Swift 6.0 + (Xcode 16.0+)
- iOS 16+

## How to Start

```swift
import GuitarChords

try await GuitarChord.synchronize()
let c = GuitarChord.search(fretString: "0_1_0_2_3_0")
```

### Quickstart

```swift
import SwiftUI
import GuitarChords

struct ChordList: View {
    @State private var chords: [Chord] = []

    private let imageRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))

    var body: some View {
        NavigationStack {
            List(chords, id: \.self.rawText) { chord in
                Section {
                    if let image = chord.image(rect: imageRect) {
                        image
                    }
                    Text(chord.name)
                        .font(.headline)
                }
            }
            .navigationTitle("Guitar Chords")
            .overlay {
                if chords.isEmpty {
                    ContentUnavailableView(
                        "Synchronizing...",
                        systemImage: "arrow.triangle.2.circlepath.icloud.fill",
                        description: Text("It will be completed soon")
                    )
                }
            }
        }
        .task {
            try? await GuitarChord.synchronize()
            chords = GuitarChord.allChords()
        }
    }
}
```

## Features

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

<img width="375" alt="스크린샷 2024-11-02 오전 2 04 04" src="https://github.com/user-attachments/assets/327bbc21-becc-42b3-b0f2-c31e552e9eb4">

`"{0_1_0_2_3_0-C}"` can be converted to `"C"` with url `"guitarchord://0_1_0_2_3_0"`.

```swift
let songMemo = """
{0_1_0_2_3_0-C}잔잔한 당신{0_0_1_2_2_0-E}은 {1_1_2_3_3_1-F}이 맘을 넘치{0_1_0_2_3_0-C}게 하지 않을거{0_1_0_2_0_0-Am7}야
그대로{1_1_2_3_3_1-F}도 편히 {2_1_2_0_x_x-D7}안길 수가 있으니{1_0_0_0_2_3-G7}까
"""

let attributedText = songMemo.regexedAttributedString()

Text(attributedText)
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

## Github Actions

| Action | Trigger | macOS | Xcode | iOS | Device |
| --- | --- | --- | --- | --- | -- |
| Build Package | `/🎼 패키지 빌드` | macOS 15 | Xcode16 | 18.0 | iPhone 16 Pro |
| Test Package in iOS18 | `/🎼 패키지 테스트 -ios18` | macOS 15 | Xcode16 | 18.0 | iPhone 16 Pro |

## Used Opened Sources 

### Swifty Chords
The below files use [Swifty Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords) sources.
- [Chord.CAShapeLayer.swift](/Sources/GuitarChords/UI/Chord.CAShapeLayer.swift)
- [LineConfig.swift](/Sources/GuitarChords/UI/LineConfig.swift)
- [NSAttributedString.Extensions](/Sources/GuitarChords/Extensions/NSAttributedString.Extensions)
- [String.Extensions](/Sources/GuitarChords/Extensions/String.Extensions)

### xcbeaufity
For GitHub Actions, [xcbeaufity](https://github.com/cpisciotta/xcbeautify) is used.
- [GitHub Actions Workflows](/.github/workflows)
