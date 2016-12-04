///
///  AVLTree.swift
///
///  Copyright (c) 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 11/25/2016.
///
import Swift

#if os(Linux) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

///
/// Generic implementation of an self-balancing AVL Tree structure
///
/// - complexity: Lookup, insertion, and deletion all take O(log n) time in both the average and worst cases, where n is the number of nodes in the tree prior to the operation
///
internal class AVLTree<ValueType: Comparable>: ExpressibleByArrayLiteral {

    public typealias NodeType = AVLTreeNode<ValueType>

    ///
    /// The root of the tree if it has any nodes
    ///
    internal fileprivate(set) var root: NodeType? = nil

    ///
    /// Construct an instance with an Array of ValueTypes
    ///
    public required convenience init(arrayLiteral values: ValueType...) {
        self.init()

        for value in values {
            self.insert(value: value)
        }
        print(self)
    }

    ///
    /// The current height of this tree
    ///
    public var height: Int {
        return self.root?.height ?? 0
    }

    ///
    /// Check to see if the tree is height balanced.
    ///
    /// - Returns: true if this tree is balanced for height
    ///
    public var balanced: Bool {
        guard let root = self.root else {
            return true
        }
        return root.balanced
    }

    ///
    /// Insert a value into the tree
    ///
    /// - Parameter value: The value to insert into the tree.
    ///
    /// - Returns: The new NodeType that was inserted.
    ///
    @discardableResult
    public func insert(value: ValueType) -> NodeType {
        return self.insert(value: value, node: &self.root)
    }

    ///
    /// Delete the value from the tree
    ///
    /// - Parameter value: The value to delete from the tree.
    ///
    public func delete(value: ValueType) -> Void {
        self.delete(value: value, node: &self.root)
    }

    ///
    /// Search for a value within the tree
    ///
    /// - Parameter value: The value to search for in the tree.
    ///
    public func search(value: ValueType) -> NodeType? {
        return self.search(value: value, start: self.root)
    }

    ///
    /// Returns in-order successor (next) of the given node
    ///
    /// In-order successor of a node is the next node in the in-order traversal of the tree. For the last node in a tree, in-order successor will be nil.
    ///
    public func next(node: NodeType) -> NodeType? {

        /// If the node has a right child then its in-order successor will be the left most node in the right subtree.
        if var subNode = node.right {
            while let left = subNode.left {
                subNode = left
            }
            return subNode
        }

        ///
        /// If the node doesnt have a right child then its in-order successor will be one of its ancestors,
        /// using parent link keep traveling up till you get the node which is the left child of its parent.
        ///
        var child = node
        var next  = child.parent           /// Start with the parent of the existing node, if nil this is the root node and there will not be a predecessor so return nil

        while let parent = next,            /// While there is a parent
                  child === parent.right {  /// and the child is the right node.

            child = parent                  /// If so, make the new child the parent of the current node
            next  = parent.parent           /// The new parent becomes the new child's parent
        }
        return next
    }

    ///
    /// Returns in-order predecessor (previous) of the given node
    ///
    public func previous(node: NodeType) -> NodeType? {

        /// If the node is a left node then its in-order predecessor will be the right most node of the left subtree.
        if var subNode = node.left {
            while let right = subNode.right {
                subNode = right
            }
            return subNode
        }

        ///
        /// If the node doesnt have a left child then its in-order predecessor will be one of its ancestors,
        /// using parent link keep traveling up till you get the node which is the right child of its parent.
        ///
        var child = node
        var next  = child.parent            /// Start with the parent of the existing node, if nil this is the root node and there will not be a predecessor so return nil

        while let parent = next,
                  child === parent.left {  /// and the child is the left node

            child = parent                  /// If so, make the new child the parent of the current node
            next  = parent.parent           /// The new parent becomes the new child's parent
        }
        return next
    }
}

///
/// Fileprivate private implementation
///
fileprivate extension AVLTree {

    ///
    /// Insert this node in the proper place in the tree ensuring it's balanced
    ///
    @inline(__always)
    @discardableResult
    fileprivate func insert(value: ValueType, node root: inout NodeType?) -> NodeType {

        ///
        /// If there is no value, we are at the insertion point
        /// so create a new node and attach
        ///
        guard let node = root else {
            let newNode = NodeType(value: value)
            root = newNode

            return newNode
        }

        if value < node.value {
            let newNode = self.insert(value: value, node: &node.left)

            /// Recalculate the heights as we unwind the stack
            root?.calculateHeight()

            self.balance(from: &root)

            return newNode
        } else if value > node.value {
            let newNode = self.insert(value: value, node: &node.right)

            /// Recalculate the heights as we unwind the stack
            root?.calculateHeight()

            self.balance(from: &root)

            return newNode
        }
        ///
        /// If equal the value is already in the tree
        /// and we ignore it returning the node we are at
        return node
    }

    ///
    /// Delete the value from the tree
    ///
    @inline(__always)
    fileprivate func delete(value: ValueType, node root: inout NodeType?) {

        guard let node = root else {
            return
        }

        if value < node.value {

            self.delete(value: value, node: &node.left)

        } else if value > node.value {

            self.delete(value: value, node: &node.right)

        } else {

            /// This is a leaf node so we can just remove it
            if node.left == nil && node.right == nil {

                root?.parent = nil
                root = nil

            } else if node.right == nil, let left = node.left {    // Node has single child (left)

                // Unlink it from it's parent
                root?.parent = nil

                // Link the left nide to the directly to the root
                left.parent = nil
                root = left

            } else if node.left == nil, let right = node.right {     // Node has single child (right)

                // Unlink the original node from it's parent
                root?.parent = nil

                // Link the left node to the directly to the root
                right.parent = nil
                root = right

            } else {                                                /// Node has both left and right children

                /// In this case we are an inner node.
                if let successor = self.next(node: node) {

                    /// Replace this node with the replacement found
                    node.value = successor.value

                    /// Now remove the old one.
                    self.delete(value: successor.value, node: &node.right)
                }
            }
        }

        /// Recalculate the heights as we unwind the stack
        root?.calculateHeight()

        self.balance(from: &root)
    }

    ///
    /// Search for a specific value in the tree.
    ///
    /// - Returns: The node containing the value if found, nil otherwise.
    ///
    @inline(__always)
    fileprivate func search(value: ValueType, start node: NodeType?) -> NodeType? {
        guard let node = node else {
            return nil
        }

        if value == node.value {
            return node
        } else if value < node.value {
            return search(value: value, start: node.left)
        } else {
            return search(value: value, start: node.right)
        }
    }
}

///
/// Tree Balance
///
fileprivate extension AVLTree {

    ///
    /// Balance the tree from the node given.
    ///
    @inline(__always)
    fileprivate func balance(from root: inout NodeType?) {

        if let node = root {

            ///
            /// Determine how to rotate the nodes if an imbalance is present.
            ///
            if node.balanceFactor > 1 {                    /// Right Heavy

                if node.right?.balanceFactor ?? 0 < 0 {    /// Right subtree is Left heavy

                    root = self.rightLeftRotate(node: node)
                } else {

                    root = self.leftRotate(node: node)
                }
            } else if node.balanceFactor < -1 {             /// Left Heavy

                if node.left?.balanceFactor ?? 0 > 0 {     /// Left subtree is Right heavy

                    root = self.leftRightRotate(node: node)
                } else {

                    root = self.rightRotate(node: node)
                }
            }
        }
    }

    ///
    /// Rotate the node tree left if there is a right node otherwise do nothing.
    ///
    /// - Parameter root: the node to start the rotation at (A right heavy minimum height 2 subtree
    ///
    /// - Returns: The new root node for this section of the tree.
    ///
    /// Example Input:
    /// ```
    ///  (A)
    ///     \   (right)
    ///     (B)
    ///       \   (right)
    ///       (C)
    /// ```
    /// Output:
    /// ```
    ///
    ///     (B)
    ///     /  \
    ///  (A)    (C)
    /// ```
    ///
    @inline(__always)
    @discardableResult
    fileprivate func leftRotate(node a: NodeType) -> NodeType? {

        var newRoot: NodeType? = nil

        if let b = a.right, b.right != nil {

            a.right = b.left    /// A's right becomes B's left
            b.left  = a         /// B's left becomes A

            /// Note: if this is the root node the parent will never be set by it's
            ///       parent (because it does not have one) so you must nil the parent
            ///       before assigning it to the root pointer
            b.parent = nil
            newRoot = b

            // Adjust the height of the nodes that changed
            a.calculateHeight()
            b.calculateHeight()
        }
        assert(newRoot != nil)

        return newRoot
    }

    ///
    /// Rotate the node tree left if there is a left node otherwise do nothing.
    ///
    /// - Parameter from: the node to start the rotation at.
    ///
    /// Example Input:
    /// ```
    ///      (C)
    ///     /    (left)
    ///    (B)
    ///   /    (left)
    /// (A)
    /// ```
    /// Output:
    /// ```
    ///
    ///     (B)
    ///     /  \
    ///  (A)    (C)
    /// ```
    ///
    @inline(__always)
    @discardableResult
    fileprivate func rightRotate(node c: NodeType) -> NodeType? {

        var newRoot: NodeType? = nil

        if let b = c.left, b.left != nil {

            c.left  = b.right  /// C's left becomes B's right
            b.right = c        /// B's right becomes C

            /// Note: if this is the root node the parent will never be set by it's
            ///       parent (because it does not have one) so you must nil the parent
            ///       before assigning it to the root pointer
            b.parent = nil
            newRoot = b

            // Adjust the height of the nodes that changed
            c.calculateHeight()
            b.calculateHeight()
        }
        assert(newRoot != nil)

        return newRoot
    }

    ///
    /// Rotate the node tree left-right (2 rotations) if there is a left node otherwise do nothing.
    ///
    /// - Parameter from: the node to start the rotation at.
    ///
    /// Example Input:
    /// ```
    ///     (C)
    ///    /    (left)
    ///  (A)
    ///    \    (right)
    ///     (B)
    /// ```
    /// Output:
    /// ```
    ///
    ///     (B)
    ///     /  \
    ///  (A)    (C)
    /// ```
    ///
    @inline(__always)
    @discardableResult
    fileprivate func leftRightRotate(node c: NodeType) -> NodeType? {

        var newRoot: NodeType? = nil

        if let a = c.left, let b = a.right {

            /// Left rotation
            a.right = b.left
            b.left = a
            c.left = b

            /// Right rotation
            c.left = b.right
            b.right = c

            /// Note: if this is the root node the parent will never be set by it's
            ///       parent (because it does not have one) so you must nil the parent
            ///       before assigning it to the root pointer
            b.parent = nil
            newRoot = b

            // Adjust the height of the nodes that changed
            a.calculateHeight()
            c.calculateHeight()
            b.calculateHeight()
        }
        assert(newRoot != nil)

        return newRoot
    }

    ///
    /// Rotate the node tree right-left (2 rotations) if there is a right node otherwise do nothing.
    ///
    /// - Parameter from: the node to start the rotation at.
    ///
    /// Example Input:
    /// ```
    /// (A)
    ///    \   (right)
    ///    (C)
    ///   /    (left)
    /// (B)
    /// ```
    /// Output:
    /// ```
    ///
    ///     (B)
    ///     /  \
    ///  (A)    (C)
    /// ```
    ///
    @inline(__always)
    @discardableResult
    fileprivate func rightLeftRotate(node a: NodeType) -> NodeType? {

        var newRoot: NodeType? = nil

        if let c = a.right, let b = c.left {

            /// Right rotate
            c.left = b.right
            b.right = c
            a.right = b

            /// Left rotate
            a.right = b.left
            b.left = a

            /// Note: if this is the root node the parent will never be set by it's
            ///       parent (because it does not have one) so you must nil the parent
            ///       before assigning it to the root pointer
            b.parent = nil
            newRoot = b

            // Adjust the height of the nodes that changed
            a.calculateHeight()
            c.calculateHeight()
            b.calculateHeight()
        }
        assert(newRoot != nil)

        return newRoot
    }
}

///
/// Node structure use to store the values of the AVL Tree.
///
internal class AVLTreeNode<ValueType: Comparable> {

    public typealias NodeType = AVLTreeNode<ValueType>

    public init(value: ValueType, parent: NodeType? = nil) {
        self.value  = value
        self.parent = parent
        self.left   = nil
        self.right  = nil

        self.left?.parent = self
        self.right?.parent = self
    }

    ///
    /// The stored value given by the user.
    ///
    public fileprivate(set) var value: ValueType

    /// Left subtree
    public var left:  NodeType? {
        willSet {
            assert(newValue !== self)

            newValue?.parent = self     /// Maintain the parent link.
        }
    }

    /// Right subtree
    public var right: NodeType? {
        willSet {
            assert(newValue !== self)

            newValue?.parent = self     /// Maintain the parent link.
        }
    }

    /// This nodes parent
    fileprivate weak var parent: NodeType? {
        willSet {
            assert(newValue !== self)
        }
    }

    ///
    /// Get height of this subtree.
    ///
    /// Height of a subtree is the number of nodes on the longest path from the root to a leaf.
    ///
    public fileprivate(set) var height: Int = 1

    ///
    /// Recalculate the height of this node.
    ///
    /// Height of a subtree is the number of nodes on the longest path from the root to a leaf.
    ///
    @inline(__always)
    fileprivate func calculateHeight() {
        self.height = 1 + Swift.max(self.left?.height ?? 0, self.right?.height ?? 0)
    }

    ///
    /// Positive (+) = Right Heavy
    /// Negative (-) = Left Heavy
    /// Zero     (0) = Equal
    ///
    public var balanceFactor: Int {
        return (self.right?.height ?? 0) - (self.left?.height ?? 0)
    }

    ///
    /// Check to see if the subtree starting at this node is height balanced.
    ///
    /// - Returns: true if this subtree is balanced for height
    ///
    public var balanced: Bool {
        return abs((self.right?.height ?? 0) - (self.left?.height ?? 0)) <= 1 && (self.left?.balanced ?? true) && (self.right?.balanced ?? true)
    }
}
