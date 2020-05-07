import XCTest
@testable import FileStream

final class FileStreamTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FileStream().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
