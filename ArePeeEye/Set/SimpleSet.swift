import Foundation

struct SimpleSet {
    private var internalSize = 0
    private var elements: [Int] = Array(repeating: -99, count: 5)
    
    func isEmpty() -> Bool {
        return internalSize == 0
    }
    
    mutating func add(_ value: Int) {
        if contains(value) {
            return
        }
        
        elements[internalSize] = value
        
        internalSize += 1
    }
    
    mutating func size() -> Int {
        return internalSize
    }
    
    func contains(_ value: Int) -> Bool {
        return index(of: value) != -1
    }
    
    mutating func remove(_ value: Int) {
        if !contains(value) {
            return
        }
        
        internalSize -= 1
        
        elements[index(of: value)] = elements[internalSize]
        
        elements[internalSize] = -99
    }
    
    private func index(of value: Int) -> Int {
        for (index, _) in elements.enumerated() {
            if elements[index] == value {
                return index
            }
        }
        
        return -1
    }
}
