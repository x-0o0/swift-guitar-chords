import SwiftUI
import Testing
import GuitarChords

@Suite("Chord UI 테스트")
struct ChordUITests {
    @Test("이미지 생성 테스트", arguments: [
        Chord(name: "C", fretString: "3_5_5_5_3_x"),
        Chord(name: "G", fretString: "3_3_0_0_2_3"),
        Chord(name: "Am", fretString: "0_1_2_3_0_0"),
        Chord(name: "F", fretString: "1_1_2_3_3_1"),
    ])
    func image(from chord: Chord) throws {
        let size = CGSize(width: 100, height: 100)
        let _ = try #require(
            chord.image(rect: CGRect(origin: .zero, size: size))
        )
    }
}
