/**
 Implementation of CodableHelper local to UnitTestingUtilities to support JsonLoader.
 TODO: this should be made into its own dependency given that it gets used in so many projects/targets
 */

import Foundation

// MARK: CodableHelperError
public enum LocalCodableHelperError: Error, CustomStringConvertible, Equatable {
    case message(String)
    case fileSystemError(errorString: String)
    case encodingError(errorString: String)
    case decodingError(errorString: String, jsonString: String)

    public var description: String {
        switch self {
        case .message(let message):
            return "message: \(message)"

        case .fileSystemError(let message):
            return "fileSystemError: \(message)"

        case .encodingError(let errorString):
            return "encodingError: \(errorString)"

        case .decodingError(let errorString, let jsonString):
            return "decodingError: \(errorString), jsonString: \(jsonString)"
        }
    }
}

class LocalCodableHelper {

    // MARK: Data
    public func encode <T: Encodable>(
        value: T
    ) -> Result<Data, LocalCodableHelperError> {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        return Result {
            try encoder.encode(value)
        }.mapError { error in
            return .encodingError(errorString: "\(error)")
        }
    }

    public func decode<T: Decodable>(
        type: T.Type,
        from data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    ) -> Result<T, LocalCodableHelperError> {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy

        return Result<T, Error> {
            try decoder.decode(type, from: data)
        }.mapError { error in
            let jsonString = data.prettyPrintedJSONString
            return .decodingError(errorString: "\(error)", jsonString: jsonString)
        }
    }
}
