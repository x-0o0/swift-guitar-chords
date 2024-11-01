/**
 - Note: See the `License.txt` file for this licensing information.
 */

extension GuitarChord {
    public enum Scope: Hashable, Sendable {
        /// GuitarChords 에 의해 관리되는 기본 저장 영역
        case service
        case custom(String)
    }
}
