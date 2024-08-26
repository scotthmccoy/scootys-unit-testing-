import Foundation

// Allows a graceful unwrapping of Optionals passed as generic arguments
protocol OptionalProtocol {
    func safeUnwrap() -> Any?
}

extension Optional: OptionalProtocol {
    func safeUnwrap() -> Any? {
        switch self {
        // If a nil is unwrapped it will crash!
        case .none: return nil
        case .some(let unwrapped): return unwrapped
        }
    }
}
