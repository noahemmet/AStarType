import AStarType
import XCTest

// MARK: Test Types

private struct GeneralLocationTrait: NodeType {
	private let location: Int
	private let range = 0...10
	
	private init(location: Int) {
		self.location = location
	}
	
	private func neighbors() -> [GeneralLocationTrait] {
		var neighbors = [GeneralLocationTrait]()
		if location > range.startIndex {
			neighbors.append(GeneralLocationTrait(location: self.location - 1))
		}
		if location < range.endIndex {
			neighbors.append(GeneralLocationTrait(location: self.location + 1))
		}
		return neighbors
	}
	
	private var cost: Int { return 1 }
	
	private static func staticFoo() {
		
	}
}

private func ==(lhs: GeneralLocationTrait, rhs: GeneralLocationTrait) -> Bool {
	return lhs.location == rhs.location
}

private struct MoveAction: ActionType {
	private typealias T = GeneralLocationTrait
	private var theType = T.self
	private var to: T?
	private var from: T?
	
	private init(from: T?, to: T?) {
		self.from = from
		self.to = to
	}
	
	private var cost: Int { 
		if let from = from?.location, let to = to?.location {
			return abs(from - to)
		}
		return 0
	}
}

private func ==(lhs: MoveAction, rhs: MoveAction) -> Bool {
	return lhs.from == rhs.from && lhs.to == rhs.to
}

// MARK: Tests

class AStarTypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
	func testCalculateEmptyPath() {
		let start = GeneralLocationTrait(location: 5)
		let end = GeneralLocationTrait(location: 5)
		let graphBuilder = GraphBuilder(start: start, goal: end, maxCost: 100)
		let path = graphBuilder.calculatePath()
		XCTAssertEqual(path!.count, 0)
	}
	
	func testCalculateFullPath() {
		let start = GeneralLocationTrait(location: 5)
		let end = GeneralLocationTrait(location: 8)
		let graphBuilder = GraphBuilder(start: start, goal: end, maxCost: 100)
		let path = graphBuilder.calculatePath()
		XCTAssertEqual(path!.last!.node.location, end.location)
		XCTAssertEqual(path!.count, end.location - start.location)
		XCTAssertEqual(path!.count, 3)
	}
}
