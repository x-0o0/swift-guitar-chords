import Testing
import GuitarChords

@Suite("Chord 모델 테스트")
struct ChordTests {
    let d_chord = Chord(name: "D", fingering: "2320xx")
    let e_chord = Chord(name: "E", fingering: "009970")
    
    @Test("고유성 테스트")
    func identifiable() throws {
        let otherEChord = Chord(name: "E", fingering: "001220")
        let unknown = Chord(name: "", fingering: "009970")
        #expect(e_chord.name == otherEChord.name)
        #expect(e_chord.id != otherEChord.id)
        #expect(e_chord.id == unknown.id)
    }
    
    @Test("줄별 프렛 번호")
    func fret() throws {
        #expect(d_chord.frets == [2, 3, 2, 0, -1, -1])
        #expect(e_chord.frets == [0, 0, 9, 9, 7, 0])
    }
    
    @Test("다이어그램에 그려질 최소 프렛 번호")
    func baseFret() throws {
        #expect(d_chord.baseFret == 1)
        #expect(e_chord.baseFret == 7)
    }
    
    @Test("다이어그램에 그려질 프렛 수")
    func numberOfFrets() throws {
        #expect(d_chord.numberOfFrets == 4)
        #expect(e_chord.numberOfFrets == 4)
    }
}
