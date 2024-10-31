import Testing
import Foundation
@testable import GuitarChords

enum SongMemo: CaseIterable {
    case 안식처_잔잔한당신은이맘을넘치게하지않을거야
    case 안식처_그대로도편히안길수가있으니까
    
    var rawText: String {
        switch self {
        case .안식처_잔잔한당신은이맘을넘치게하지않을거야:
            "{0_1_0_2_3_0-C} 잔잔한 당신{0_0_1_2_2_0-E}은 {1_1_2_3_3_1-F}이 맘을 넘치{0_1_0_2_3_0-C}게 하지 않을거{0_1_0_2_0_0-Am7}야"
        case .안식처_그대로도편히안길수가있으니까:
            "그대로{1_1_2_3_3_1-F}도 편히 {2_1_2_0_x_x-D7}안길 수가 있으니{1_0_0_0_2_3-G7}까"
        }
    }
    
    var displayedText: String {
        switch self {
        case .안식처_잔잔한당신은이맘을넘치게하지않을거야:
            "C 잔잔한 당신E은 F이 맘을 넘치C게 하지 않을거Am7야"
        case .안식처_그대로도편히안길수가있으니까:
            "그대로F도 편히 D7안길 수가 있으니G7까"
        }
    }
    
    var links: [URL] {
        switch self {
        case .안식처_잔잔한당신은이맘을넘치게하지않을거야:
            [
                URL(string: "guitarchord://0_1_0_2_3_0")!,
                URL(string: "guitarchord://0_0_1_2_2_0")!,
                URL(string: "guitarchord://1_1_2_3_3_1")!,
                URL(string: "guitarchord://0_1_0_2_3_0")!,
                URL(string: "guitarchord://0_1_0_2_0_0")!,
            ]
        case .안식처_그대로도편히안길수가있으니까:
            [
                URL(string: "guitarchord://1_1_2_3_3_1")!,
                URL(string: "guitarchord://2_1_2_0_x_x")!,
                URL(string: "guitarchord://1_0_0_0_2_3")!,
            ]
        }
    }
}

@Suite("Chord 정규표현식 테스트")
struct ChordRegexTests {
    @Test("정규표현식 테스트", arguments: [
        "{3_5_5_5_3_x-C}",
        "{3_3_0_0_2_3-G}",
        "{0_1_2_3_0_0-Am}",
        "{1_1_2_3_3_1-F}",
        "{0_1_0_0_2_0-MyChord}",
    ])
    func chordRegex(from rawText: String) throws {
        /// 1: 변환
        let regex = try #require(try NSRegularExpression(pattern: Chord.pattern, options: []))
        let range = NSRange(rawText.startIndex..<rawText.endIndex, in: rawText)
        let result = regex.stringByReplacingMatches(
            in: rawText,
            options: [],
            range: range,
            withTemplate: "<a href=\"frets://$1\">$2</a>"
        )
        
        /// 2: 결과비교
        let chord = try #require(try Chord(rawText: rawText))
        #expect(result == "<a href=\"frets://\(chord.fretString)\">\(chord.name)</a>")
    }
    
    @Test("코드 포함 텍스트 변환 테스트", arguments: SongMemo.allCases)
    func regexedAttributedString(_ songMemo: SongMemo) throws {
        let attributedString = songMemo.rawText.regexedAttributedString()
        
        /// 표출 문구
        #expect(String(attributedString.characters) == songMemo.displayedText)
        /// 링크 (`guitarchord://`)
        attributedString.runs.forEach { run in
            if let link = run.attributes.link {
                #expect(songMemo.links.contains(link))
            }
        }
    }
}
