/**
 - Note: See the `License.txt` file for this licensing information.
 */

import Foundation

extension UserDefaults {
    nonisolated(unsafe)
    static let guitarChords = UserDefaults(suiteName: "swift-guitar-chords")
}
