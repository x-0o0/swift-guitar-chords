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

| Light Mode | Dark Mode |
| --- | --- |
| <img width="345" alt="스크린샷 2024-10-03 오전 3 54 54" src="https://github.com/user-attachments/assets/076f331a-9df6-4193-b433-83354c659efd"> | <img width="339" alt="스크린샷 2024-10-03 오전 3 55 02" src="https://github.com/user-attachments/assets/7632ffab-87d8-4606-87b4-ffdb5f3e4288"> |

