import XCTest

class DummyClass {}

public extension XCTestCase {

    var testImageUrl: URL {
        let myBundle = Bundle(for: DummyClass.self)

        // Get the URL to the resource bundle within the bundle
        // of the current class.
        let resourceBundleURL = myBundle.url(
            forResource: "UnitTestingUtilitiesResources.bundle",
            withExtension: nil
        )!

        // Create a bundle object for the bundle found at that URL.
        let resourceBundle = Bundle(
            url: resourceBundleURL
        )!
        
        return resourceBundle.url(forResource: "tv_test_pattern.jpeg", withExtension: nil)!
    }

    var testImageData: Data {
        // swiftlint:disable:next force_try
        try! Data(contentsOf: testImageUrl)
    }

    func countedExpectation(description: String) -> CountedXCTestExpectation {
        let expectation = expectation(description: description)
        return CountedXCTestExpectation(expectation: expectation)
    }
}
