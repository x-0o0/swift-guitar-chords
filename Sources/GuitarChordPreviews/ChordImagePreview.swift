/**
 - Note: See the `License.txt` file for this licensing information.
 */

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
        ChordImagePreview(chord: Chord(name: "C", fretString: "0_1_0_2_3_0"), isDarkMode: true)
        
        ChordImagePreview(chord: Chord(name: "C", fretString: "3_5_5_5_3_x"), isDarkMode: true)
    }
    .preferredColorScheme(.dark)
}

#Preview("C 코드") {
    HStack {
        ChordImagePreview(chord: Chord(name: "C", fretString: "0_1_0_2_3_0"))
        
        ChordImagePreview(chord: Chord(name: "C", fretString: "8_8_9_10_10_8"))
    }
}

#Preview("G 코드") {
    ChordImagePreview(chord: Chord(name: "G", fretString: "3_3_0_0_2_3"))
}

#Preview("Am 코드") {
    ChordImagePreview(chord: Chord(name: "Am", fretString: "5_5_5_7_7_5"))
}

#Preview("F 코드") {
    ChordImagePreview(chord: Chord(name: "F", fretString: "1_1_2_3_3_1"))
}
