import XCTest
@testable import FileStream

final class FileStreamTests: XCTestCase {
    func testNextLine() {
        let path = "Tests/TestFile.txt"
        var values: [String] = []
        let testValues: [String] = [
            "charmander",
            "charmeleon",
            "charizard",
            "bulbasaur",
            "ivysaur",
            "venusaur",
            "squirtle",
            "wartortle",
            "blastoise"
        ]
        
        do {
            let fstream = try FileStream(path: path)
            while let line = fstream.nextLine() {
                values.append(line)
            }
        } catch FileStreamError.UnableToOpenFile {
            print("Unable to open file at \(path)")
        } catch FileStreamError.BadDelimiter {
            print("Try using a different delimiter")
        } catch {
            print("Unknown Error")
        }
        
        XCTAssertEqual(values, testValues)
    }
    
    static var allTests = [
        ("testNextLine", testNextLine),
    ]
}
