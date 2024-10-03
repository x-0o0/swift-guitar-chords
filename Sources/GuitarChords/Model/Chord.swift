/**
 - Note: See the `License.txt` file for this licensing information.
 */

import Foundation

public struct Chord: Identifiable, Codable, Equatable {
    /// 코드 이름. 예) "C", "Am"
    public let name: String
    /// 운지법.
    /// ```swift
    /// "2320xx"
    /// // 1번째 줄: 2번 프렛
    /// // 2번째 줄: 3번 프렛
    /// // 3번째 줄: 2번 프렛
    /// // 4번째 줄: 누르지 않음
    /// // 5번째 줄: 뮤트
    /// // 6번째 줄: 뮤트
    /// ```
    public let fretString: String
    
    public var id: String { fretString }

    public var frets: [Int] {
        fretString.map { Int(String($0)) ?? -1 }
    }
    
    public var maxFret: Int {
        frets.max() ?? 0
    }
    
    /// 가장 큰 숫자가 3 이하면 1, 그렇지 않으면 0이 아닌 최소값
    public var baseFret: Int {
        maxFret <= 3
        ? 1
        : frets.filter { $0 > 0 }.min() ?? 1
    }
    
    /// `baseFret` 와 가장 큰 프렛 차이에 따른 계산
    public var numberOfFrets: Int {
        let fretDifference = maxFret - baseFret
        return fretDifference <= 3
        ? 4
        : fretDifference
    }
    
    public var rawText: String {
        "{\(fretString)-\(name)}"
    }
    
    public init(name: String, fretString: String) {
        self.name = name
        self.fretString = fretString
    }
    
    public init(rawText: String) throws {
        guard rawText.isWrappedByBraces else {
            throw NSError(domain: "INVALID_RAW_TEXT", code: 400)
        }
        let trimmedString = rawText.trimmingCharacters(in: CharacterSet(charactersIn: "{}"))
        let components = trimmedString.components(separatedBy: "-")
        guard components.count == 2 else {
            throw NSError(domain: "INVALID_RAW_TEXT", code: 400)
        }
        guard components[0].count == 6 else {
            throw NSError(domain: "INVALID_FRESTS_COUNT", code: 400)
        }
        self.fretString = components[0]
        self.name = components[1]
    }
}

extension String {
    var isWrappedByBraces: Bool {
        self.hasPrefix("{") && self.hasSuffix("}")
    }
}
