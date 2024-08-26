import XCTest

public extension XCTestExpectation {
    var expected: Bool {
        get {
            !self.isInverted
        }
        set {
            self.isInverted = !newValue
        }
    }
}

public extension Optional where Wrapped == XCTestExpectation {

    // keystroke saver for unwrapping an expectation and fulfilling it, or failing the test (instead of crashing)
    func fulfillOrFail(
        _ xcTestCase: XCTestCase,
        file: StaticString = #file,
        line: UInt = #line,
        function: StaticString = #function
    ) {
        guard let expectation = self else {
            let msg = "Unexpected call to \(function)"

            let location = XCTSourceCodeLocation(
                filePath: file,
                lineNumber: line
            )
            let sourceCodeContext = XCTSourceCodeContext(location: location)

            let xctIssue = XCTIssue(
                type: .assertionFailure,
                compactDescription: msg,
                detailedDescription: msg,
                sourceCodeContext: sourceCodeContext,
                associatedError: nil,
                attachments: []
            )

            xcTestCase.record(xctIssue)
            return
        }

        expectation.fulfill()
    }
}

