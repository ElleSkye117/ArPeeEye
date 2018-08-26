import Foundation

struct SimpleSet {
    private var internalSize = 0
    private var elements: [Int?]
    
    init() {
        self.init(capacity: 5)
    }
    
    init(capacity: Int) {
        elements = Array(repeating: nil, count: capacity)
    }
    
    func isEmpty() -> Bool {
        return internalSize == 0
    }
    
    mutating func add(_ value: Int) {
        if contains(value) {
            return
        }
        
        if full() {
            grow()
            
            print("elements")
            print(elements)
        }
        
        elements[internalSize] = value
        
        internalSize += 1
    }
    
    mutating func size() -> Int {
        return internalSize
    }
    
    func contains(_ value: Int) -> Bool {
        return index(of: value) != nil
    }
    
    mutating func remove(_ value: Int) {
        if !contains(value) {
            return
        }
        
        internalSize -= 1
        
        elements[index(of: value)!] = elements[internalSize]
        
        elements[internalSize] = nil
    }

    private func index(of value: Int) -> Int? {
        for (index, _) in elements.enumerated() {
            if elements[index] == value {
                return index
            }
        }
        
        return nil
    }
    
    private func full() -> Bool {
        return internalSize == elements.count
    }
    
    private mutating func grow() {
        var largerElements: [Int?] = Array(repeating: nil, count: elements.count * 2)
        
        for (index, element) in elements.enumerated() {
            largerElements[index] = element
        }
        
        elements = largerElements
    }
}
