/**
 - Note: See the `License.txt` file for this licensing information.
 */

import Foundation

public struct Chord: Identifiable, Equatable {
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
    public let fingering: String
    
    public var id: String { fingering }

    public var frets: [Int] {
        fingering.map { Int(String($0)) ?? -1 }
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
    
    public init(name: String, fingering: String) {
        self.name = name
        self.fingering = fingering
    }
}
