import Foundation

// MARK: GraphNode

public class GraphNode<T:NodeType where T: Equatable>: Equatable {
	public var node: T
	public var key: String?
	public var parent: Box<GraphNode<T>>?
	public var visited: Bool = false
	public var cost: Int
	public var edges: [GraphEdge<T>] {
		var edges = [GraphEdge<T>]()
		for neighbor in node.neighbors() {
			let toGraphNode = GraphNode(node: neighbor, parent: self)
			let graphEdge = GraphEdge(from: self, to: toGraphNode, weight: 1)
			edges.append(graphEdge)
		}
		return edges
	}
	
	func edgeNodes() -> [GraphNode<T>] {
		return edges.map{ $0.to }
	}
	
	public convenience init(node: T) {
		self.init(node: node, parent: nil)
	}
	
	public init(node: T, parent: GraphNode?) {
		self.node = node
		if let parent = parent {
			self.parent = Box(parent)
		}
		cost = node.cost
	}
}

public func == <T: NodeType>(lhs: GraphNode<T>, rhs: GraphNode<T>) -> Bool {
	return	lhs === rhs
}

// MARK: GraphEdge

public class GraphEdge<T:NodeType where T: Equatable>: Equatable {
	public var from: GraphNode<T>
	public var to: GraphNode<T>
	public var weight: Int = 1
	public var f, g, h: Int
	public init(from: GraphNode<T>, to: GraphNode<T>, weight: Int) {
		self.from = from
		self.to = to
		self.weight = weight
		f = 0
		g = 0
		h = 0
	}
}

public func == <T: NodeType>(lhs: GraphEdge<T>, rhs: GraphEdge<T>) -> Bool {
	return  lhs.from == rhs.from &&
		lhs.to == rhs.to
}

// MARK: GraphPath

public struct GraphPath<N:NodeType where N: Equatable> {
	public let path: [GraphNode<N>]
	public let totalCost: Int
	
	public init(path: [GraphNode<N>]) {
		print(path.count)
		self.path = path
		totalCost = path.reduce(0) { $0 + $1.cost }
	}
}


// MARK: NavGraph

public struct GraphBuilder<N: NodeType where N:Equatable> {	
	let start: N
	let goal: N
	let maxCost: Int?
	
	public init(start: N, goal: N, maxCost: Int?) {
		self.start = start
		self.goal = goal
		self.maxCost = maxCost
	}
	
	public func calculatePath() -> [GraphNode<N>]? {
		var startNav = GraphNode(node: start)
		var goalNav = GraphNode(node: goal)
		
		var path = [N]()
		var open = [startNav]
		var closed = [GraphNode<N>]()
		var length = 0
		while !open.isEmpty {
			
			// Grab the lowest f(x) to process next.
			var lowIndex = 0;
			for i in 0 ..< open.count {
				if open[i].cost < open[lowIndex].cost {
					lowIndex = i
				}
			}
			
			var currentNode = open[lowIndex]
			// End case -- result has been found, return the traced path.
			if currentNode.node == goalNav.node {
				var curr = currentNode;
				var ret = [GraphNode<N>]();
				while(curr.parent != nil) {
					ret.append(curr)
					curr = curr.parent!.value;
				}
				ret.reverse()
			}
			
			// Normal case -- move currentNode from open to closed, process each of its neighbors.
			let i = find(open, currentNode)!
			open.removeAtIndex(i)
			closed.append(currentNode)
			
			for (index, neighbor) in enumerate(currentNode.edgeNodes()) {
				// not a valid node to process, skip to next neighbor
				if contains(closed, neighbor) {
					continue
				}
				
				// g score is the shortest distance from start to current node, we need to check if
				// the path we have arrived at this neighbor is the shortest one we have seen yet.
				var gScore = currentNode.cost + 1 //// 1 is the distance from a node to its neighbor.
				var gScoreIsBest = false
				
				if !contains(open, neighbor) {
					// This the the first time we have arrived at this node, it must be the best
					// Also, we need to take the h (heuristic) score since we haven't done so yet
					gScoreIsBest = true
					// I think we need to compare node IDs or something
					//					neighbor.to.cost = astar.heuristic(neighbor.pos, end.pos);
					open.append(neighbor)
				} else if(gScore < neighbor.cost) {
					// We have already seen the node, but last time it had a worse g (distance from start)
					gScoreIsBest = true;
				}
				
				if(gScoreIsBest) {
					// Found an optimal (so far) path to this node.	 Store info on how we got here and
					//	just how good it really is...
					neighbor.parent = Box(currentNode);
					//					neighbor.g = gScore;
					//					neighbor.f = neighbor.g + neighbor.h;
					//					neighbor.debug = "F: " + neighbor.f + "<br />G: " + neighbor.g + "<br />H: " + neighbor.h;
				}
			}
		}
		// No result was found -- empty array signifies failure to find path
		return nil
	}
}