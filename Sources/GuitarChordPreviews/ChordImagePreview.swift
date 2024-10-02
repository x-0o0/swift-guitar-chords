import SwiftUI
import GuitarChords

struct ChordImagePreview: View {
    let chord: Chord
    let isDarkMode: Bool
    let rect = CGRect(x: 0, y: 0, width: 90, height: 90)
    
    var body: some View {
        VStack {
            if let image = chord.image(
                rect: rect,
                primaryColor: isDarkMode ? .systemBackground : .label
            ) {
                image
            }
            
            Text("baseFret: \(chord.baseFret)")
            
            Text("maxFret: \(chord.maxFret)")
            
            Text("numberOfFret: \(chord.numberOfFrets)")
        }
    }
    
    init(chord: Chord, isDarkMode: Bool = false) {
        self.chord = chord
        self.isDarkMode = isDarkMode
    }
}

#Preview("다크 모드") {
    HStack {
        ChordImagePreview(chord: Chord(name: "C", fingering: "010230"), isDarkMode: true)
        
        ChordImagePreview(chord: Chord(name: "C", fingering: "35553x"), isDarkMode: true)
    }
    .preferredColorScheme(.dark)
}

#Preview("C 코드") {
    HStack {
        ChordImagePreview(chord: Chord(name: "C", fingering: "010230"))
        
        ChordImagePreview(chord: Chord(name: "C", fingering: "35553x"))
    }
}

#Preview("G 코드") {
    ChordImagePreview(chord: Chord(name: "G", fingering: "330023"))
}

#Preview("G 코드") {
    ChordImagePreview(chord: Chord(name: "Am", fingering: "555775"))
}

#Preview("Am 코드") {
    ChordImagePreview(chord: Chord(name: "F", fingering: "112331"))
}
