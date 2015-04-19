import Foundation

public protocol EdgeType {
	typealias T: NodeType
	var theType: T.Type { get }
	var to: T? { get }
	var from: T? { get }
	var cost: Int { get }
	init(from: T?, to: T?)
}
