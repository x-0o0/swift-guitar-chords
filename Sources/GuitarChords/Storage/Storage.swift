/**
 - Note: See the `License.txt` file for this licensing information.
 */

import OSLog
import Foundation

extension GuitarChord {
    class Storage {
        let scope: GuitarChord.Scope
        let fileURL: URL
        
        private(set) var chords: Set<Chord>
        
        init(scope: GuitarChord.Scope, intialChords: Set<Chord> = [], fileURL: URL) {
            self.scope = scope
            self.fileURL = fileURL
            self.chords = []
        }
        
        init(scope: GuitarChord.Scope, data: Data, fileURL: URL) throws {
            self.scope = scope
            self.fileURL = fileURL
            let syncChord = try JSONDecoder().decode(SyncChords.self, from: data)
            self.chords = Set(syncChord.chords)
        }
        
        func add(_ chord: Chord) throws {
            chords.insert(chord)
            try writeFile()
        }
        
        func remove(matchingID id: String) throws {
            let chord = self.chords.first { $0.id == id }
            guard let chord else { return }
            try remove(chord)
        }
        
        func remove(_ chord: Chord) throws {
            try writeFile()
            chords.remove(chord)
        }
        
        private func writeFile() throws {
            let syncChords = SyncChords(chords: Array(chords))
            let data = try JSONEncoder().encode(syncChords)
            try data.write(to: fileURL)
        }
    }
}
