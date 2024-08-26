import Foundation

protocol SwiftInitEncodingContainer: AnyObject {
    var encodedValue: String { get }

    init(
        codingPath: [CodingKey],
        userInfo: [CodingUserInfoKey: Any]
    )
}

final class SwiftInitEncoder {

    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any]

    fileprivate var container: SwiftInitEncodingContainer?

    init(
        codingPath: [CodingKey] = [],
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }

    var encodedValue: String {
        container?.encodedValue ?? ""
    }

    func encode(
        _ value: Encodable
    ) throws -> String {
        try value.encode(to: self)

        // Tabify argument list
        let argList = encodedValue
            .split(separator: "\n")
            .map { line in
                "\t" + line
            }.joined(separator: "\n")

        // Create initialization statement
        let typeName = type(of: value)
        let ret = "\(typeName)(\n\(argList)\n)"
        return ret
    }
}

extension SwiftInitEncoder: Encoder {

    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }

    func container<Key>(
        keyedBy type: Key.Type
    ) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        assertCanCreateContainer()

        let container = SwiftInitKeyedEncodingContainer<Key>(
            codingPath: self.codingPath,
            userInfo: self.userInfo
        )
        self.container = container

        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        assertCanCreateContainer()

        let container = SwiftInitUnkeyedEncodingContainer(
            codingPath: self.codingPath,
            userInfo: self.userInfo
        )
        self.container = container

        return container
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        assertCanCreateContainer()

        let container = SwiftInitSingleValueEncodingContainer(
            codingPath: self.codingPath,
            userInfo: self.userInfo
        )
        self.container = container

        return container
    }
}
