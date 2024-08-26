import XCTest

// Loads & Decodes JSON from Unit Test Bundle.
public enum JsonLoaderError: Error {
    case fileNotFound
    case couldNotGetData(Error)
    case codableHelperError(LocalCodableHelperError)
}

public class JsonLoader {

    private var bundle: Bundle
    
    public init(anyClass: AnyClass) {
        self.bundle = Bundle(for: anyClass)
    }

    public func load<T: Decodable>(
        type: T.Type,
        filename: String,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    ) -> Result<T, JsonLoaderError> {

        // Get path
        guard let url = bundle.url(forResource: filename, withExtension: nil) else {
            return .failure(.fileNotFound)
        }

        // Get data
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            return .failure(.couldNotGetData(error))
        }

        // Decode
        return LocalCodableHelper().decode(
            type: type,
            from: data,
            keyDecodingStrategy: keyDecodingStrategy,
            dateDecodingStrategy: dateDecodingStrategy
        ).mapError {
            .codableHelperError($0)
        }
    }

    public func loadData(filename: String) -> Data? {
        guard let path = bundle.url(forResource: filename, withExtension: nil) else {
            return nil
        }
        do {
            return try Data(contentsOf: path)
        } catch {
            return nil
        }
    }
}
