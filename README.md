# GuitarChords

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
