import Foundation

final class SwiftInitSingleValueEncodingContainer {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any]

    fileprivate var canEncodeNewValue = true
    private var storage = ""

    init(
        codingPath: [CodingKey],
        userInfo: [CodingUserInfoKey: Any]
    ) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }

    fileprivate func checkCanEncode(value: Any?) throws {
        guard self.canEncodeNewValue else {
            let context = EncodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Cannot encode multiple values."
            )
            throw EncodingError.invalidValue(value as Any, context)
        }
    }

    func handle<T>(value: T) throws where T: Encodable {
        switch value {
        case is String:
            storage.append("\"\(value)\"")

        case
            is Bool,
            is Double,
            is Float,
            is Int,
            is Int16,
            is Int32,
            is Int64,
            is Int8,
            is UInt,
            is UInt16,
            is UInt32,
            is UInt64,
            is UInt8:
            storage.append("\(value)")

        case let url as URL:
            let urlString = url.absoluteString
            storage.append("URL(string: \"\(urlString)\")")

        default:
            let swiftInitEncoder = SwiftInitEncoder(
                codingPath: codingPath,
                userInfo: userInfo
            )
            let initStatement = try swiftInitEncoder.encode(value)
            self.storage.append(initStatement)
        }
    }
}

extension SwiftInitSingleValueEncodingContainer: SingleValueEncodingContainer {

    func encodeNil() throws {
        try checkCanEncode(value: nil)
        defer { self.canEncodeNewValue = false }
        storage.append("nil")
    }

    func encode<T>(_ value: T) throws where T: Encodable {
        try checkCanEncode(value: nil)
        defer { self.canEncodeNewValue = false }

        // Check if Optional
        guard let optional = value as? OptionalProtocol else {
            try handle(value: value)
            return
        }

        // Handle Optionals
        guard let unwrapped = optional.safeUnwrap() as? Encodable else {
            storage.append("nil")
            return
        }

        try handle(value: unwrapped)
    }
}

extension SwiftInitSingleValueEncodingContainer: SwiftInitEncodingContainer {
    var encodedValue: String {
        storage
    }
}
