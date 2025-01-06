/**
 - Note: See the `License.txt` file for this licensing information.
 */

import Foundation

public final class GuitarChord {
    nonisolated(unsafe)
    private(set) static var service: GuitarChordService = GuitarChordService()
    
    /// The URL that all guitar chords are stored
    /// - NOTE: Should call ``GuitarChordService/synchronize`` to set value.
    public static var serviceURL: URL? {
        service.serviceURL
    }
    /// The custom scopes to store the chords.
    /// | String | URL |
    /// | --- | --- |
    /// | `registerCustomScope(named:)` 에서의 파라미터 값 | 파일 저장소 경로 |
    public static var customScopes: [String: URL] {
        service.customScopes
    }
    
    // MARK: - 동기화
    public static func synchronize() async throws {
        try await service.synchronize()
    }
    
    // MARK: - 코드 검색
    public static func search(named chordName: String, scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        service.search(named: chordName, scopes: scopes)
    }
    
    public static func search(fretString: String, scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        service.search(fretString: fretString, scopes: scopes)
    }
    
    public static func allChords(scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        service.allChords(scopes: scopes)
    }
    
    // MARK: - 커스텀 코드 관리
    public static func registerCustomScope(named scopeName: String) throws {
        try service.registerCustomScope(named: scopeName)
    }
    
    public static func unregisterCustomScope(named scopeName: String) throws {
        try service.unregisterCustomScope(named: scopeName)
    }
    
    public static func addChord(_ chord: Chord, to scope: GuitarChord.Scope) throws {
        try service.addChord(chord, to: scope)
    }
    
    public static func deleteChord(byID id: String, from scope: GuitarChord.Scope) throws {
        try service.deleteChord(byID: id, from: scope)
    }
}
