import XCTest

@testable import ArePeeEye

class Specs: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testExistence() {
        let set = Set()
        
        XCTAssertNotNil(set)
    }
}
