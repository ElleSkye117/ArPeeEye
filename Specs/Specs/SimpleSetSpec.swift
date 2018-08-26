import XCTest

@testable import ArePeeEye

// Note: For this exercise, we are going to prentend that Swift arrays are dumb.  They have an initial capacity
// and can only access and remove elements using the index subscript.

class SimpleSetSpec: XCTestCase {
    var empty: SimpleSet!
    var one: SimpleSet!
    var many: SimpleSet!
    
    override func setUp() {
        super.setUp()
        
        empty = SimpleSet()
        
        one = SimpleSet()
        one.add(1)
        
        many = SimpleSet()
        many.add(1)
        many.add(2)
    }
    
    func testExistence() {
        let set = SimpleSet()
        
        XCTAssertNotNil(set)
    }
    
    func testIsEmpty() {
        XCTAssertTrue(empty.isEmpty())
        XCTAssertFalse(one.isEmpty())
        XCTAssertFalse(many.isEmpty())
    }
    
    func testSize() {
        XCTAssertEqual(empty.size(), 0)
        XCTAssertEqual(one.size(), 1)
        XCTAssertTrue(many.size() > 1)
    }
    
    func testContains() {
        XCTAssertFalse(empty.contains(1))
        XCTAssertFalse(empty.contains(2))
        
        XCTAssertTrue(one.contains(1))
        XCTAssertFalse(one.contains(2))
        
        XCTAssertTrue(many.contains(1))
        XCTAssertTrue(many.contains(2))
    }
    
    func testRemove() {
        var set = SimpleSet()
        set.add(1)
        set.add(2)
        
        set.remove(1)
        
        XCTAssertEqual(set.size(), 1)
        XCTAssertFalse(set.contains(1))
    }
    
    func testIgnoresDuplicates() {
        one.add(1)
        
        XCTAssertEqual(one.size(), 1)
    }
    
    func testGrows() {
        var set = SimpleSet(capacity: 1)
        
        set.add(1)
        set.add(2)
        
        XCTAssertEqual(set.size(), 2)
    }
}
