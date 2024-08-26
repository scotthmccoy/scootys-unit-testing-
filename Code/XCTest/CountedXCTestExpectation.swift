import XCTest

public struct CountedXCTestExpectation {
    public let expectation: XCTestExpectation
    public private(set) var currentFulfillmentCount: Int = 0

    public mutating func fulfill() {
        currentFulfillmentCount += 1
        expectation.fulfill()
    }
}
