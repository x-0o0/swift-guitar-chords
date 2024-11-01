/**
 - Note: See the `License.txt` file for this licensing information.
 */

extension Chord {
    /// 코드 정규 표현식
    /// - 운지법: `([0-9x_]{11})`: `0`~`9`, `x`, `_` 로 구성된 11자리 문자열
    /// - 코드명: `([A-Za-z0-9_\u{4E00}-\u{9FFF}\u{AC00}-\u{D7AF}\u{3040}-\u{30FF}]+)`: 한국어, 영어, 한자, 일본어, 숫자, 밑줄로 구성
    static let pattern = "\\{([0-9x_]{11})-([A-Za-z0-9_\u{4E00}-\u{9FFF}\u{AC00}-\u{D7AF}\u{3040}-\u{30FF}]+)\\}"
}
