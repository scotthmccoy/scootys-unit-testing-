import Foundation

final class SwiftInitUnkeyedEncodingContainer {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any]

    var storage: [SwiftInitEncodingContainer] = []

    private var nestedCodingPath: [CodingKey] {
        return self.codingPath + [Index(intValue: self.count)!]
    }

    init(
        codingPath: [CodingKey],
        userInfo: [CodingUserInfoKey: Any]
    ) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }

    struct Index: CodingKey {
        var intValue: Int?

        var stringValue: String {
            return "\(self.intValue!)"
        }

        init?(intValue: Int) {
            self.intValue = intValue
        }

        init?(stringValue: String) {
            return nil
        }
    }
}

extension SwiftInitUnkeyedEncodingContainer: UnkeyedEncodingContainer {

    var count: Int {
        storage.count
    }

    func encodeNil() throws {
        var container = self.nestedSingleValueContainer()
        try container.encodeNil()
    }

    func encode<T>(
        _ value: T
    ) throws where T: Encodable {
        var container = self.nestedSingleValueContainer()
        try container.encode(value)
    }

    private func nestedSingleValueContainer() -> SingleValueEncodingContainer {
        let container = SwiftInitSingleValueEncodingContainer(
            codingPath: self.nestedCodingPath,
            userInfo: self.userInfo
        )
        self.storage.append(container)

        return container
    }

    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        let container = SwiftInitKeyedEncodingContainer<NestedKey>(
            codingPath: self.nestedCodingPath,
            userInfo: self.userInfo
        )

        self.storage.append(container)
        return KeyedEncodingContainer(container)
    }

    // For Arrays
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = SwiftInitUnkeyedEncodingContainer(
            codingPath: self.nestedCodingPath,
            userInfo: self.userInfo
        )

        self.storage.append(container)
        return container
    }

    func superEncoder() -> Encoder {
        fatalError("Not Implemented")
    }
}

extension SwiftInitUnkeyedEncodingContainer: SwiftInitEncodingContainer {
    var encodedValue: String {
        storage.map {
            $0.encodedValue
        }.joined(separator: ",")
    }
}
