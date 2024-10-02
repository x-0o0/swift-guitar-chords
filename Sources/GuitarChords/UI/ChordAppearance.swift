import SwiftUI

extension EnvironmentValues {
    public var chordAppearance: ChordAppearance {
        get { self[ChordAppearanceKey.self] }
        set { self[ChordAppearanceKey.self] = newValue }
    }
}

private struct ChordAppearanceKey: EnvironmentKey {
    static var defaultValue: ChordAppearance = ChordAppearance(primary: .primary, background: Color(.systemBackground))
}

/// ```swift
/// @Environment(\.chordAppearance) var appearance
/// ```
public struct ChordAppearance {
    /// The primary label color.
    public let primary: Color
    /// The background color.
    public let background: Color
    
    public init(primary: Color, background: Color) {
        self.primary = primary
        self.background = background
    }
}
