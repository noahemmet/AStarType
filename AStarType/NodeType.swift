import Foundation

// MARK: NodeType

public protocol NodeType {
	func neighbors() -> [Self]
	var cost: Int { get }
	static func staticFoo()
}

public struct KeyOfNodeType: Hashable {
	
	let id: ObjectIdentifier
	public let type: Any.Type
	public var hashValue: Int { return id.hashValue }
	public init?(_ value: NodeType) {
		type = value.dynamicType.self as! Any.Type
		id = ObjectIdentifier(type)
	}
}

public func ==(lhs: KeyOfNodeType, rhs: KeyOfNodeType) -> Bool {
	return lhs.id == rhs.id
}
