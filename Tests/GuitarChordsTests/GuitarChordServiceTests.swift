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
        
        let serviceStorage = try #require(service.chordStorage[.service])
        #expect(serviceStorage.fileURL == fileURL)
        #expect(!serviceStorage.chords.isEmpty)
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
    
    @Test("코드명 기반 코드 검색", arguments: [
        "F",
        "C",
        "G",
        "Em",
    ])
    func searchChord(named chordName: String) async throws {
        /// 사전조건: 동기화가 성공해야함
        try await service.synchronize()
        
        let results = service.search(named: chordName, scopes: [.service])
        print(results)
        #expect(!results.isEmpty)
        results.forEach {
            #expect($0.name == chordName)
        }
    }
    
    @Test("운지법 기반 코드 검색", arguments: [
        "0_1_0_2_3_0",
        "1_1_2_3_3_1",
        "3_0_0_0_2_3",
        "0_0_0_2_2_0",
    ])
    func searchChord(fretString: String) async throws {
        /// 사전조건: 동기화가 성공해야함
        try await service.synchronize()
        
        let results = service.search(fretString: fretString, scopes: [.service])
        print(results)
        #expect(!results.isEmpty)
        results.forEach {
            #expect($0.fretString == fretString)
        }
    }
    
    @Test("저장된 모든 코드 가져오기", arguments: [
        [GuitarChord.Scope.service]
    ])
    func allChords(scopes: [GuitarChord.Scope]) async throws {
        /// 사전조건: 동기화가 성공해야함
        try await service.synchronize()
        
        let allChords = service.allChords(scopes: scopes)
        print(allChords)
        #expect(!allChords.isEmpty)
    }
    
    @Test("코드 추가하기", arguments: [
        (Chord(name: "MyChord", fretString: "0_1_0_0_3_0"), "user.created")
    ])
    func addChord(_ chord: Chord, to scopeName: String) async throws {
        /// 사전조건: 등록이 성공해야함
        try service.registerCustomScope(named: scopeName)
        try service.addChord(chord, to: .custom(scopeName))
        
        let allChords = service.allChords(scopes: [.custom(scopeName)])
        print(allChords)
        #expect(allChords.contains(chord))
    }
    
    @Test("등록 전 코드 추가하기", arguments: [
        (Chord(name: "MyChord", fretString: "0_1_0_0_3_0"), "user.created")
    ])
    func addChordButNoScope(_ chord: Chord, to scopeName: String) async throws {
        #expect(
            throws: GuitarChordError.needToRegisterScope,
            "등록하기 전에 Scope에 접근하려 하므로 'needToRegisterScope' 에러를 던져야 합니다."
        ) {
            try service.addChord(chord, to: .custom(scopeName))
        }
    }
    
    @Test("코드 제거하기", arguments: [
        (Chord(name: "MyChord", fretString: "0_1_0_0_3_0"), "user.created")
    ])
    func deleteChord(_ chord: Chord, from scopeName: String) async throws {
        /// 사전조건: 등록이 성공해야함
        try service.registerCustomScope(named: scopeName)
        try service.deleteChord(byID: chord.id, from: .custom(scopeName))
    }
    
    @Test("Scope 등록 전 코드 제거하기", arguments: [
        (Chord(name: "MyChord", fretString: "0_1_0_0_3_0"), "user.created")
    ])
    func deleteChordButNoScope(_ chord: Chord, from scopeName: String) async throws {
        #expect(
            throws: GuitarChordError.needToRegisterScope,
            "등록하기 전에 Scope에 접근하려 하므로 'needToRegisterScope' 에러를 던져야 합니다."
        ) {
            try service.deleteChord(byID: chord.id, from: .custom(scopeName))
        }
    }
}
