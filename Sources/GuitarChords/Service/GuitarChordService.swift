//
//  GuitarChordService.swift
//  swift-guitar-chords
//
//  Created by 이재성 on 11/1/24.
//

import Foundation

public class GuitarChordService {
    // MARK: - 동기화
    public func synchronize() async throws {
        guard let url = URL(string: "https://raw.githubusercontent.com/songforms/data-space/main/guitar-chords/chords.json") else {
            throw NSError(domain: "guitarchord://error.synchronize", code: 4000)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
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
        let fileURL = folderURL.appendingPathComponent("chords.json")
        try data.write(to: fileURL)
    }
    
    // MARK: - 코드 검색
    public func search(named chordName: String, scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        // TODO: Impl.
        []
    }
    
    public func search(fretString: String, scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        // TODO: Impl.
        []
    }
    
    public func allChords(scopes: [GuitarChord.Scope] = [.service]) -> [Chord] {
        // TODO: Impl.
        []
    }
    
    // MARK: - 커스텀 코드 관리
    var customScopes: [String: URL] = [:]
    
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
    
    public func addChord(rawText: String, to scope: GuitarChord.Scope) throws {
        // TODO: Impl.
    }
    
    public func deleteChord(byID id: String, from scope: GuitarChord.Scope) throws {
        // TODO: Impl.
    }
}
