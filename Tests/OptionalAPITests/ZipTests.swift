import XCTest
import OptionalAPI
import SnapshotTesting

fileprivate let a: Int? = 1
fileprivate let b: Int? = 2
fileprivate let c: Int? = 3
fileprivate let d: Int? = 4
fileprivate let e: Int? = 5
fileprivate let f: Int? = 6
fileprivate let g: Int? = 7
fileprivate let h: Int? = 8
fileprivate let i: Int? = 9
fileprivate let j: Int? = 0

class ZipTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        record = false
    }
    
    func test_zips() {
        XCTAssertTrue( zip(a, b, c, d, e, f, g, h, i, j).isSome )
        XCTAssertTrue( zip(a, b, c, d, e, f, g, h, i).isSome )
        XCTAssertTrue( zip(a, b, c, d, e, f, g, h).isSome )
        XCTAssertTrue( zip(a, b, c, d, e, f, g).isSome )
        XCTAssertTrue( zip(a, b, c, d, e, f).isSome )
        XCTAssertTrue( zip(a, b, c, d, e).isSome )
        XCTAssertTrue( zip(a, b, c, d).isSome )
        XCTAssertTrue( zip(a, b, c).isSome )
        XCTAssertTrue( zip(a, b).isSome )
    }
    
    func test_zips_snapshosts() {
        assertSnapshot(matching: zip(a, b, c, d, e, f, g, h, i, j), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e, f, g, h, i), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e, f, g, h), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e, f, g), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e, f), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d, e), as: .dump)
        assertSnapshot(matching: zip(a, b, c, d), as: .dump)
        assertSnapshot(matching: zip(a, b, c), as: .dump)
        assertSnapshot(matching: zip(a, b), as: .dump)
    }
}
