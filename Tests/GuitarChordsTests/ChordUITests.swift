import SwiftUI
import Testing
import GuitarChords

@Suite("Chord UI 테스트")
struct ChordUITests {
    @Test("이미지 생성 테스트", arguments: [
        Chord(name: "C", fingering: "35553x"),
        Chord(name: "G", fingering: "330023"),
        Chord(name: "Am", fingering: "012300"),
        Chord(name: "F", fingering: "112331"),
    ])
    func image(from chord: Chord) throws {
        let size = CGSize(width: 100, height: 100)
        let _ = try #require(
            chord.image(rect: CGRect(origin: .zero, size: size))
        )
    }
}
