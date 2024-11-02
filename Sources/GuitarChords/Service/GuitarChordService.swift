/**
 - Note: See the `License.txt` file for this licensing information.
 */

import OSLog
import Foundation

public class GuitarChordService {
    // MARK: - 동기화
    var chordStorage: [GuitarChord.Scope: GuitarChord.Storage] = [:]
    
    /// - NOTE: Should call ``GuitarChordService/synchronize`` to set value.
    private(set) public var serviceURL: URL?
    private(set) public var customScopes: [String: URL] = [:]
    
    public func synchronize() async throws {
        guard let url = URL(string: "https://raw.githubusercontent.com/songforms/data-space/main/guitar-chords/chords.json") else {
            throw NSError(domain: "guitarchord://error.synchronize", code: 4000)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let fileURL: URL
        if let url = UserDefaults.guitarChords?.value(forKey: "service.url") as? URL {
            fileURL = url
        } else {
            let folderURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            .appending(path: "swift-guitar-chords", directoryHint: .isDirectory)
            .appending(path: "service", directoryHint: .isDirectory)
            
            try FileManager.default.createDirectory(
                at: folderURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            fileURL = folderURL.appendingPathComponent("chords.json")
        }
        try data.write(to: fileURL)
        self.serviceURL = fileURL
        
        let chordStorage = try GuitarChord.Storage(
            scope: .service, data: data, fileURL: fileURL
        )
        self.chordStorage.updateValue(chordStorage, forKey: .service)
    }
    
    // MARK: - 코드 검색
    public func search(named chordName: String, scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        if scopes.contains(.service), serviceURL == nil {
            let error = GuitarChordError.needToSynchronize
            Logger.scope.error("\(error.localizedDescription)")
        }
        
        var chords: Set<Chord> = []
        scopes.forEach { scope in
            guard let storage = chordStorage[scope] else { return }
            let filteredChords = storage.chords
                .filter { $0.name == chordName }
            chords = chords.union(filteredChords)
        }
        return Array(chords)
    }
    
    public func search(fretString: String, scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        if scopes.contains(.service), serviceURL == nil {
            let error = GuitarChordError.needToSynchronize
            Logger.scope.error("\(error.localizedDescription)")
        }
        
        var chords: Set<Chord> = []
        scopes.forEach { scope in
            guard let storage = chordStorage[scope] else { return }
            let filteredChords = storage.chords
                .filter { $0.fretString == fretString }
            chords = chords.union(filteredChords)
        }
        return Array(chords)
    }
    
    public func allChords(scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        if scopes.contains(.service), serviceURL == nil {
            let error = GuitarChordError.needToSynchronize
            Logger.scope.error("\(error.localizedDescription)")
        }
        
        var chords: Set<Chord> = []
        scopes.forEach { scope in
            guard let storage = chordStorage[scope] else { return }
            let filteredChords = storage.chords
            chords = chords.union(filteredChords)
        }
        return Array(chords)
    }
    
    // MARK: - 커스텀 코드 관리
    
    public func registerCustomScope(named scopeName: String) throws {
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appending(path: "swift-guitar-chords", directoryHint: .isDirectory)
        .appending(path: "custom", directoryHint: .isDirectory)
        
        try FileManager.default.createDirectory(
            at: folderURL,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let fileURL = folderURL.appendingPathComponent("\(scopeName).json")
        
        customScopes.updateValue(fileURL, forKey: scopeName)
    }
    
    public func unregisterCustomScope(named scopeName: String) throws {
        let fileURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .deletingPathExtension()
        .appendingPathComponent("swift-guitar-chords")
        .appendingPathComponent("custom")
        .appendingPathComponent("\(scopeName).json")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            try FileManager.default.removeItem(atPath: fileURL.path())
        }
        customScopes.removeValue(forKey: scopeName)
    }
    
    public func addChord(_ chord: Chord, to scope: GuitarChord.Scope) throws {
        let fileURL: URL?
        switch scope {
        case .service:
            fileURL = serviceURL
        case .custom(let name):
            fileURL = customScopes[name]
        }
        guard let fileURL else {
            throw GuitarChordError.needToRegisterScope
        }
        
        if let storage = chordStorage[scope] {
            try storage.add(chord)
        } else {
            let storage = GuitarChord.Storage(scope: scope, fileURL: fileURL)
            try storage.add(chord)
            chordStorage.updateValue(storage, forKey: scope)
        }
    }
    
    public func deleteChord(byID id: String, from scope: GuitarChord.Scope) throws {
        switch scope {
        case .service:
            if serviceURL == nil {
                throw GuitarChordError.needToRegisterScope
            }
        case .custom(let name):
            if customScopes[name] == nil {
                throw GuitarChordError.needToRegisterScope
            }
        }
        let storage = chordStorage[scope]
        try storage?.remove(matchingID: id)
    }
}
