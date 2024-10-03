import Foundation

// swiftlint:disable:next type_name
struct SwiftInitKeyedEncodingContainerStorageItem {
    let anyCodingKey: AnyCodingKey
    let swiftInitEncodingContainer: SwiftInitEncodingContainer
}

final class SwiftInitKeyedEncodingContainer<Key> where Key: CodingKey {
    private var storage = [SwiftInitKeyedEncodingContainerStorageItem]()

    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any]

    func nestedCodingPath(forKey key: CodingKey) -> [CodingKey] {
        return self.codingPath + [key]
    }

    init(
        codingPath: [CodingKey],
        userInfo: [CodingUserInfoKey: Any]
    ) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }

    func make<T: SwiftInitEncodingContainer> (
        containerType: T.Type,
        key: Key
    ) -> T {
        // print("key: \(key)")

        // Get the coding path with the new key added to it
        let codingPath = self.nestedCodingPath(forKey: key)

        // Create the SwiftInitCodingContainer
        // Note that it won't be used until .encode(value) is called on it
        let swiftInitEncodingContainer = containerType.init(
            codingPath: codingPath,
            userInfo: self.userInfo
        )

        // Make a type-erased CodingKey
        let anyCodingKey = AnyCodingKey(key)

        // Make a storage item
        // swiftlint:disable:next identifier_name
        let swiftInitKeyedEncodingContainerStorageItem = SwiftInitKeyedEncodingContainerStorageItem(
            anyCodingKey: anyCodingKey,
            swiftInitEncodingContainer: swiftInitEncodingContainer
        )

        // Add the storage item to the storage array
        self.storage.append(swiftInitKeyedEncodingContainerStorageItem)

        return swiftInitEncodingContainer
    }
}

extension SwiftInitKeyedEncodingContainer: KeyedEncodingContainerProtocol {

    func encodeNil(
        forKey key: Key
    ) throws {
        // print("key: \(key)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encodeNil()
    }

    func encode<T>(
        _ value: T,
        forKey key: Key
    ) throws where T: Encodable {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent<T>(
        _ value: T,
        forKey key: Key
    ) throws where T: Encodable {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    // Used for dicts/structs
    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        // print("key: \(key), keyType: \(keyType)")
        let swiftInitKeyedEncodingContainer = make(
            containerType: SwiftInitKeyedEncodingContainer<NestedKey>.self,
            key: key
        )

        return KeyedEncodingContainer(swiftInitKeyedEncodingContainer)
    }

    // Used for arrays
    func nestedUnkeyedContainer(
        forKey key: Key
    ) -> UnkeyedEncodingContainer {
        // print("key: \(key)")
        let swiftInitUnkeyedEncodingContainer = make(
            containerType: SwiftInitUnkeyedEncodingContainer.self,
            key: key
        )

        return swiftInitUnkeyedEncodingContainer
    }

    // Used for members of structs
    private func nestedSingleValueContainer(
        forKey key: Key
    ) -> SingleValueEncodingContainer {
        // print("key: \(key)")
        let swiftInitUnkeyedEncodingContainer = make(
            containerType: SwiftInitSingleValueEncodingContainer.self,
            key: key
        )

        return swiftInitUnkeyedEncodingContainer
    }

    func superEncoder() -> Encoder {
        fatalError("Unimplemented")
    }

    func superEncoder(forKey key: Key) -> Encoder {
        fatalError("Unimplemented")
    }

    func encode(_ value: Bool, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: Double, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: Float, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: Int, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: Int16, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: Int32, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: Int64, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: Int8, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: String, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: UInt, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: UInt16, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: UInt32, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: UInt64, forKey key: Key) throws {
        // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encode(_ value: UInt8, forKey key: Key) throws {
        // // print("key: \(key), value: \(value)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeConditional<T>(_ object: T, forKey key: Key) throws where T: AnyObject, T: Encodable {
        // print("key: \(key), object: \(object)")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(object)
    }

    func encodeIfPresent(_ value: Bool?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: Double?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: Float?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: Int16?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: Int32?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: Int64?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: Int8?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: Int?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: String?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: UInt16?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: UInt32?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: UInt64?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: UInt8?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent(_ value: UInt?, forKey key: Key) throws {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    func encodeIfPresent<T>(_ value: T?, forKey key: Key) throws where T: Encodable {
        // print("key: \(key), value: \(String(describing: value))")
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }
}

extension SwiftInitKeyedEncodingContainer: SwiftInitEncodingContainer {
    var encodedValue: String {

        // Create argument list
        return storage
        // Convert to array of (key, value) tuples
        // swiftlint:disable:next identifier_name
        .map { swiftInitKeyedEncodingContainerStorageItem in
            let argName = swiftInitKeyedEncodingContainerStorageItem.anyCodingKey.stringValue
            let argValue = swiftInitKeyedEncodingContainerStorageItem.swiftInitEncodingContainer.encodedValue

            return "\(argName): \(argValue)"
        }.joined(separator: ",\n")
    }
}
