//
//  GuitarChord.swift
//  swift-guitar-chords
//
//  Created by 이재성 on 11/1/24.
//

public final class GuitarChord {
    nonisolated(unsafe)
    private(set) static var service: GuitarChordService = GuitarChordService()
    
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
    
    public static func addChord(rawText: String, to scope: GuitarChord.Scope) throws {
        try service.addChord(rawText: rawText, to: scope)
    }
    
    public static func deleteChord(byID id: String, from scope: GuitarChord.Scope) throws {
        try service.deleteChord(byID: id, from: scope)
    }
}
