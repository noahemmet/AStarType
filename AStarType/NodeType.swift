import Foundation

// MARK: NodeType

public protocol NodeType {
	func neighbors() -> [Self]
	var cost: Int { get }
	static func staticFoo()
}
