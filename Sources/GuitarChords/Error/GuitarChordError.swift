/**
 - Note: See the `License.txt` file for this licensing information.
 */

import Foundation

public enum GuitarChordError: Error {
    case needToSynchronize
    case needToRegisterScope
    
    var localizedDescription: String {
        switch self {
        case .needToSynchronize:
            return "You should call 'GuitarChord.synchronize()' first."
        case .needToRegisterScope:
            return "You should call 'registerCustomScope(named:)' to register custom scope."
        }
    }
}
