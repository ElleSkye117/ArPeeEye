# Swift ArePeeEye Script

### We are going to build a `SimpleSet` in Swift using TDD.  TDD is where we write tests first, and then implemented the most basic amount of code to the the tests passing.  Once the tests pass, we look for pieces of code we can refactor.  This is also referred to as Red-Green-Refactor.  Ok let’s begin:

### Q. Do you know what a set is?  If so, explain it’s properties

* A set is a collection that has unique objects contained that are unordered.

__As you can see I created a test class and file for our `SimpleSet`.__

__To get started let’s begin with implementing the `isEmpty()` method.__

```swift
func testIsEmpty() {
  let set = SimpleSet()
  XCTAssertTrue(set.isEmpty())
}
```

__Since this won’t build due to the lack of the `isEmpty()` method, let’s create that method:__

```swift
func isEmpty() {
  return false
}
```

__As we can see the test fails.__

### Q. What is the most basic thing we can do to make this test pass?

* Return `true` in `isEmpty()` method

__Now when use a `SimpleSet`, we should test empty sets, and sets with objects in them.  Let’s create some more sets to tests:__

```swift
func testIsEmpty() {
  let empty = SimpleSet()

  var one = SimpleSet()
  one.add(1)

  var many = SimpleSet()
  many.add(1)
  many.add(2)

  XCTAssertTrue(empty.isEmpty())
  XCTAssertFalse(one.isEmpty())
  XCTAssertFalse(many.isEmpty())
}
````

__This test drives us to implement an add method in order to build:__

```swift
func add(_ value: Int) {

}
```

__We will leave the method blank for now and run the tests and they fail.__

### Q. What is the simplest thing we can do to make the tests pass?

* Create a variable that defaults to `true` then change it to `false` when the `add()` is called.

```swift
...

private var internalIsEmpty = false

...

func isEmpty -> Bool {
  return internalIsEmpty
}

func add(_ value: Int) {
  internalIsEmpty = true
}

```

__Next we will test size.  Let’s copy and paste the tests from the `isEmpty()` tests.__

```swift
func testSize() {
  let empty = SimpleSet()

  var one = SimpleSet()
  one.add(1)

  var many = SimpleSet()
  many.add(1)
  many.add(2)

  XCTAssertEqual(0, empty.size());
  XCTAssertEqual(1, one.size());

  ...
}
```

### Q. How should we test the many set?

* To be more descriptive, let’s make it `many.size() > 1`, instead of testing `many.size() == 2`
* `XCTAssertTrue(many.size() > 1)`;

__Let’s add the method, and watch the tests fail:__

```swift
func size() -> Int {
  return 0
}
```

### Q. What is the simplest thing we can do to make this pass?

* We can create another property that will increment every time the `add()` method is called.

```swift
...

private var internalSize = 0

...

mutating func add(_ value: Int) {
  internalSize += 1
  internalIsEmpty = false
}

mutating func size() -> Int {
  return internalSize
}
```

### Q. Now that we are passing, can you see a refactor?

* `internalIsEmpty` is redundant, we can rely just on the `internalSize` property and check the count.

```swift
func isEmpty() -> Bool {
  return internalSize == 0
}

func add(_ value: Int) {
  internalSize += 1
}
```

__Still green, so let’s refactor the tests, as we can create all our objects for each test using `setUp()`:__

```swift
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

  ...

  func testIsEmpty() {
    XCTAssertTrue(empty.isEmpty());
    XCTAssertFalse(one.isEmpty());
    XCTAssertFalse(many.isEmpty());
  }

  func testSize() {
    XCTAssertEqual(0, empty.size());
    XCTAssertEqual(1, one.size());
    XCTAssertTrue(many.size() > 1);
  }

  ...
}
```

__Let’s test contains. Lets just assert the `empty/one/many` sets we created to see if they contain the objects we added.__

```swift
func testContains() {
  XCTAssertFalse(empty.contains(1))
  XCTAssertFalse(empty.contains(2))

  XCTAssertTrue(one.contains(1))
  XCTAssertFalse(one.contains(2))

  XCTAssertTrue(many.contains(1))
  XCTAssertTrue(many.contains(2))
}
```

__Then we just create a default `contains()` method that returns `true`__

```swift
func contains(_ value: Int) -> Bool {
  return false;
}
```

### Q. How can we fix these tests?

* We now need a data structure to keep these objects.
* We will pretend that the Swift arrays are dumb and don't have any re-sizing, fancy collection methods.
* Since we don’t care about expansion at this moment, use a small finite size

__Let’s create an array that will hold 5 objects for now:__

```swift
private var internalSize = 0
private var elements: [Int?] = Array(repeating: nil, count: 5)
```

### Q. How do we change the add method?

* We loop through all the elements until we find what we are looking for.  
* We need to use `(index, element)` enumeration since we can’t use length of the elements array.

```swift
mutating func contains(_ value: Int) -> Bool {
  for (index, _) in elements.enumerated() {
    if elements[index] == value {
      return true
    }
  }

  return false
}
```

__Remove is next.__

### Q. After looking at the variable names for the previous tests, do you see a problem with using the same names for the remove tests?

* Create a new instance of `SimpleSet` inside the remove spec
* Make it more descriptive to what we are doing for removals that makes it easier to read for somebody else on the project

```swift
func testRemove() {
  var set = SimpleSet()
  set.add(1)
  set.add(2)

  set.remove(1)
}
```

### Q. What kind of assertions should we do to check if the remove method works?

* We check that the size is now `1`,
* We check that the set no longer contains what we removed.

```swift
func testRemove() {
  var set = SimpleSet()
  set.add(1)
  set.add(2)

  set.remove(1)

  XCTAssertEqual(set.size(), 1)
  XCTAssertFalse(set.contains(1))
}
```

### Q. How are we going to implement remove?

* Iterate through the array and find the object that should be removed.
* Remove by setting element in array to `nil`

### Q. Is there any problems you see with removal?

* We will have sparse arrays to deal with if we just set elements to `nil`
* An easy fix is to move the element at the end of the array in it’s spot
* Decrement the size.  
* For cleanup we also nil out the element being copied

```swift
mutating func remove(_ value: Int) {
  for (index, _) in elements.enumerated() {
    if elements[index] == value {
      internalSize -= 1

      elements[index] = elements[internalSize]

      elements[internalSize] = nil
    }
  }
}
```

__Now we are green.__

### Q. Is there anything you think we can refactor?

* Yes we can refactor iteration loop by creating a private method that finds an `index`
* If it finds it, it returns the `index`, else it returns `nil`

```swift
private func index(of value: Int) -> Int? {
  for (index, _) in elements.enumerated() {
    if elements[index] == value {
        return index
    }
  }

  return nil
}
```

### Q. How do we refactor contains, and remove?

* We can just check to see if we have `nil` or not with `contains()`, and we can also check to see if we have `nil` to remove, and if we do we bail, else we do the element swapping.

```swift
func contains(_ value: Int) -> Bool {
  return index(of: value) != nil
}

mutating func remove(_ value: Int) {
  let indexOfValue = index(of: value)

  if indexOfValue == nil {
    return
  } else {
      internalSize -= 1

      elements[indexOfValue!] = elements[internalSize]

      elements[internalSize] = nil
  }
}
```

### Q. It looks like remove is doing something that contains is doing for us, how can we further refactor this code?

* Use `contains()` method instead of using the `index` when deciding if we need to bail out

```swift
mutating func remove(_ value: Int) {
  if !contains(value) {
    return
  }

  internalSize -= 1

  elements[index(of: value)!] = elements[internalSize]

  elements[internalSize] = nil
}
```

### Q. What are the pros and cons of this refactor?

Pro - It is cleaner and easier to read
Con - We are looping twice, `2N` instead of `N`

### Q. Based on our requirements, should we care about optimization at this point?

* Since we have no requirements about speed, we don’t care
* Pre-optimization can waste time

__Let’s test duplicates__

### Q. What kind of assertions can we do to test that our sets don’t add duplicates?

* We add the same object twice, check the size of the array and make sure it didn’t grow.

```swift
func testIgnoresDuplicates() {
  one.add(1)

  XCTAssertEqual(one.size(), 1)
}
```

### Q. Since that fails, what do we do to fix it?

* We can check if the set contains it in the `add()` method.
* If it does, we bail, else we add it

```swift
mutating func add(_ value: Int) {
  if contains(value) {
    return
  }

  elements[internalSize] = value

  internalSize += 1
}
```

__Now we are going to handle the case where we need to grow our `elements` array beyond it's initial capacity.  Let's write test that allows us to test this effectively.  I'm going to introduce an `init()` method that allows us to set an initial capacity.  Here is the spec:__

```swift
func testGrows() {
    var set = SimpleSet(capacity: 1)
}
```

__Let's allow this test to drive our implemenation of a new `init()` method.__

```swift
init() {
  self.init(capacity: 5)
}

init(capacity: Int) {
  elements = Array(repeating: nil, count: capacity)
}
```

__As you can see we needed to add a "vanilla" `init()` method since once we implement the new `init(capactity:)` method Swift gets rid of our "freebee" `struct` one.__

### Q. Do we need the construction of the `elements` array at the property level?

* No, because we will always be setup now at the `initMethod()` level.

```swift
private var internalSize = 0
private var elements: [Int?]
```

__Now let's start to build out the actual spec.__

```swift
func testGrows() {
  var set = SimpleSet(capacity: 1)

  set.add(1)
  set.add(2)

  XCTAssertEqual(set.size(), 2)
}
```

### Q. What is going to happen when we attempt to add the second element in the array?

* We will crash because we will be going out of range of the `elements` array

__What we need is a check in the `add()` method that will see if the `elements` array is full, and then expand it if it is.__

### Q. Do we want the check before or after the contains check statement in the `add()` method?

* After the contains check so that way we don't expand the array unnecessarily if we already have the item being added.

```swift
mutating func add(_ value: Int) {
  if contains(value) {
    return
  }

  if isElementsArrayFull() {
    expandElementsArray()
  }

  ...
```

### Q. How do we determine if we are full?

* We check to see if our `internalSize` property is equal to `elements.count`.

```swift
private func isElementsArrayFull() -> Bool {
  return internalSize == elements.count
}
```

### How do we expand the `elements` array?

* We can expand it by some arbitrary value (doubling it is good enough), and then copy the elements from the current `elements` array into the expanded array and then set the current `elements` array to the newly expanded array.

```swift
private mutating func expandElementsArray() {
  var largerElements: [Int?] = Array(repeating: nil, count: elements.count * 2)

  for (index, element) in elements.enumerated() {
    largerElements[index] = element
  }

  elements = largerElements
}
```

### Q. Do you see the value of this exercise?  Is this something you want to be doing full time?
