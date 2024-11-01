import Testing
import Foundation

@testable import GuitarChords

@Suite("GuitarChordService 테스트")
struct GuitarChordServiceTests {
    
    let service = GuitarChordService()
    
    @Test("동기화 테스트")
    func synchronize() async throws {
        try await service.synchronize()
        
        let folderURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appending(path: "swift-guitar-chords", directoryHint: .isDirectory)
        .appending(path: "service", directoryHint: .isDirectory)
        
        let fileURL = folderURL.appendingPathComponent("chords.json")
        
        let data = try Data(contentsOf: fileURL)
        let syncChord = try JSONDecoder().decode(SyncChordResponse.self, from: data)
        print(syncChord.chords)
        #expect(!syncChord.chords.isEmpty)
    }
    
    @Test("커스텀 Scope 등록 테스트", arguments: [
        "user.created.0",
        "user.created.1",
        "user.created.2",
        "user.created.3",
    ])
    func registerCustomScope(named scopeName: String) throws {
        try service.registerCustomScope(named: scopeName)
        let scopeURL = try #require(service.customScopes[scopeName])
        print(scopeURL)
        #expect(scopeURL.absoluteString.hasSuffix("\(scopeName).json"))
    }
    
    @Test(
        "커스텀 Scope 등록해지 테스트",
        arguments: [
            "user.created.0",
            "user.created.1",
            "user.created.2",
            "user.created.3",
        ]
    )
    func unregisterCustomScope(named scopeName: String) throws {
        /// 사전조건: 등록이 성공해야함
        try service.registerCustomScope(named: scopeName)
        try service.unregisterCustomScope(named: scopeName)
        #expect(service.customScopes[scopeName] == nil)
    }
}
