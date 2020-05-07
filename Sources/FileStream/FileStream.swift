import Foundation

public class FileStream  {
    
    // MARK: - Properties
    
    private let chunkSize : Int
    private let delimData : Data
    private let encoding : String.Encoding

    private var buffer : Data
    private var fileHandle : FileHandle!

    public var atEOF : Bool
    
    // MARK: - Lifecycle
    
    init(path: String, delimiter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) throws {
    
        guard let fileHandle = FileHandle(forReadingAtPath: path) else { throw FileStreamError.UnableToOpenFile }
        guard let delimData = delimiter.data(using: encoding) else { throw FileStreamError.BadDelimiter }
            
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEOF = false
    }
    
    deinit {
        self.close()
    }
}

// MARK: - API

public extension FileStream {
    func nextLine() -> String? {
        while !atEOF {
            if let range = buffer.range(of: delimData) {
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                atEOF = true
                if buffer.count > 0 {
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
    
    func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEOF = false
    }
    
    func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}
