import Foundation


public protocol ActionType {
	typealias T: NodeType
	var theType: T.Type { get }
	var to: T? { get }
	var from: T? { get }
	var cost: Int { get }
	init(from: T?, to: T?)
}

public struct KeyOfActionType: Hashable {
	
	public let id: ObjectIdentifier
	public let type: Any.Type
	public var hashValue: Int { return id.hashValue }
	public init?<T: ActionType>(_ value: T) {
		type = value.dynamicType.self
		id = ObjectIdentifier(type)
	}
}

public func ==(lhs: KeyOfActionType, rhs: KeyOfActionType) -> Bool {
	return lhs.id == rhs.id
}

public struct KeyType: Hashable {
	let id: ObjectIdentifier
	public let type: Any.Type
	public var hashValue: Int { return id.hashValue }
	public init?(_ type: Any.Type) {
		self.type = type
		id = ObjectIdentifier(type)
	}
}

public func ==(lhs: KeyType, rhs: KeyType) -> Bool {
	return lhs.id == rhs.id
}
