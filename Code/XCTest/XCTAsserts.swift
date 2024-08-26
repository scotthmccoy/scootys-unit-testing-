import XCTest

public func XCTAssertContains(
    _ haystack: String,
    _ needle: String,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    if haystack.contains(needle) {
        return
    }

    XCTFail("Expected \"\(haystack)\" to contain \"\(needle)\"", file: file, line: line)
}

public func XCTAssertStartsWith(
    _ string: String,
    _ expectedPrefix: String,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    if string.starts(with: expectedPrefix) {
        return
    }

    XCTFail("Expected \"\(string)\" to start with \"\(expectedPrefix)\"", file: file, line: line)
}

/**
Improvement over XCTAssertEqual for use with Encodable arguments (see SwiftInitEncoder)
 */
public func XCTAssertEqualEncodable<T: Encodable>(
    expected: T,
    actual: T,
    file: StaticString = #filePath,
    line: UInt = #line
) where T: Equatable {
    if expected == actual {
        return
    }
    
    // Encode both args into Swift Init Statements
    guard
        case let .success(expectedInitStatement) = (Result {
            try SwiftInitEncoder().encode(expected)
        }),
        case let .success(actualInitStatement) = (Result {
            try SwiftInitEncoder().encode(actual)
        }) else {
        // If the encoding fails, gracefully fall back to XCTAssertEqual
        XCTAssertEqual(expected, actual, file: file, line: line)
        return
    }
    
    // Get the line-by-line difference between the two init statements
    // and convert to a git diff style format
    let expectedInitStatementLines = expectedInitStatement.split(separator: "\n")
    let actualInitStatementLines = actualInitStatement.split(separator: "\n")
    let strDiff = expectedInitStatementLines.difference(
        from: actualInitStatementLines
    ).map {
        switch $0 {
        case .insert(let offset, let element, associatedWith: _):
            return "\(offset): + \(element)"
            
        case .remove(let offset, let element, associatedWith: _):
            return "\(offset): - \(element)"
        }
    }.joined(separator: "\n")
    
    XCTFail(
        // swiftlint:disable:next line_length
        "\nactual:\n\(actualInitStatement)\n\nexpected:\n\(expectedInitStatement)\n\nMake the following changes:\n\(strDiff)",
        file: file,
        line: line
    )
}
