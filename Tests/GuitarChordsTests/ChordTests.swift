import Testing
import Foundation
import GuitarChords

@Suite("Chord 모델 테스트")
struct ChordTests {
    let d_chord = Chord(name: "D", fretString: "2320xx")
    let e_chord = Chord(name: "E", fretString: "009970")
    
    @Test("디코딩 테스트")
    func decode() throws {
        let jsonString = """
        {
          "name": "C",
          "fretString": "010230"
        }
        """
        let decoded = try JSONDecoder().decode(Chord.self, from: jsonString.data(using: .utf8)!)
        #expect(decoded.name == "C")
        #expect(decoded.fretString == "010230")
    }
    
    @Test("Raw text 생성자 테스트")
    func initializeWithRawText() throws {
        // 1. valid
        let chord1 = try #require(try Chord(rawText: "{010230-C}"))
        #expect(chord1.fretString == "010230")
        #expect(chord1.name == "C")
        
        let chord2 = try #require(try Chord(rawText: "{01003x-my_own_chord}"))
        #expect(chord2.fretString == "01003x")
        #expect(chord2.name == "my_own_chord")
        
        let chord3 = try #require(try Chord(rawText: "{01003x-}"))
        #expect(chord3.fretString == "01003x")
        #expect(chord3.name.isEmpty)
        
        // 2. no braces
        let invalidRawTextError = NSError(domain: "INVALID_RAW_TEXT", code: 400)
        #expect(throws: invalidRawTextError) {
            let _ = try Chord(rawText: "010230-C")
        }
        
        // 3. wrong frets
        let invalidFretsCountError = NSError(domain: "INVALID_FRESTS_COUNT", code: 400)
        #expect(throws: invalidFretsCountError) {
            let _ = try Chord(rawText: "{01023-wrongfrets}")
        }
    }
    
    @Test("고유성 테스트")
    func identifiable() throws {
        let otherEChord = Chord(name: "E", fretString: "001220")
        let unknown = Chord(name: "", fretString: "009970")
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
