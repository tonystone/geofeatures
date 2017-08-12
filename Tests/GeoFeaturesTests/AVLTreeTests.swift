///
///  AVLTreeTests.swift
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
///  Created by Tony Stone on 11/26/2016.
///
import XCTest
@testable import GeoFeatures

///
/// Test AVL Trees
///
/// AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25)
///
/// 1)         8
///          /   \
/// 2)      5     15
///        / \    / \
/// 3)    1   7  10  20
///                 /  \
/// 4)             17  25
///
///
/// AVLTree<String>(arrayLiteral: "A", "B", "C")
/// AVLTree<String>(arrayLiteral: "C", "B", "A")
/// AVLTree<String>(arrayLiteral: "C", "A", "B")
///
/// 1)      B
///        /  \
/// 2)    A    C
///

///
/// Main Test class
///
class AVLTreeTests: XCTestCase {

    // MARK: Rotation func Tests

    func testLeftRotation() {
        let input: AVLTree<String> = ["A", "B", "C"]
        let expected = (height: 2, balanced: true)

        XCTAssertEqual(input.height, expected.height)
        XCTAssertEqual(input.balanced, expected.balanced)
    }

    func testRightRotation() {
        let input: AVLTree<String> = ["C", "B", "A"]
        let expected = (height: 2, balanced: true)

        XCTAssertEqual(input.height, expected.height)
        XCTAssertEqual(input.balanced, expected.balanced)
    }

    func testLeftRightRotation() {
        let input: AVLTree<String> = ["C", "A", "B"]
        let expected = (height: 2, balanced: true)

        XCTAssertEqual(input.height, expected.height)
        XCTAssertEqual(input.balanced, expected.balanced)
    }

    func testRightLeftRotation() {
        let input: AVLTree<String> = ["A", "C", "B"]
        let expected = (height: 2, balanced: true)

        XCTAssertEqual(input.height, expected.height)
        XCTAssertEqual(input.balanced, expected.balanced)
    }

    // MARK: Height Tests

    func testHeightEmptyTree() {
        let input = AVLTree<Int>()
        let expected = 0

        XCTAssertEqual(input.height, expected)
    }

    func testHeight() {
        let input: AVLTree<Int> = [1, 5, 8, 7, 10, 15, 20, 17, 25]
        let expected = 4

        XCTAssertEqual(input.height, expected)
    }

    func testBalancedEmptyTree() {
        let input = AVLTree<Int>()
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testBalanced9NodeTree() {
        let input: AVLTree<Int> = [1, 5, 8, 7, 10, 15, 20, 17, 25]
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testBalanced1NodeTree() {
        let input: AVLTree<Int> = [1]
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testBalanced2NodeTree() {
        let input: AVLTree<Int> = [1, 5]
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testBalanced3NodeRightHeavyTree() {
        let input: AVLTree<Int> = [1, 5, 8]
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testHeight3NodeRightHeavyTree() {
        let input: AVLTree<Int> = [1, 5, 8]
        let expected = 2

        XCTAssertEqual(input.height, expected)
    }

    func testBalanced3NodeLeftHeavyTree() {
        let input: AVLTree<Int> = [8, 5, 1]
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testHeight3NodeLeftHeavyTree() {
        let input: AVLTree<Int> = [8, 5, 1]
        let expected = 2

        XCTAssertEqual(input.height, expected)
    }

    func testBalanced3NodeLeftRightHeavyTree() {
        let input: AVLTree<Int> = [8, 1, 5]
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testHeight3NodeLeftRightHeavyTree() {
        let input: AVLTree<Int> = [8, 1, 5]
        let expected = 2

        XCTAssertEqual(input.height, expected)
    }

    func testBalanced3NodeOrderedTree() {
        let input: AVLTree<Int> = [5, 1, 8]
        let expected = true

        XCTAssertEqual(input.balanced, expected)
    }

    func testInsertNonExisting30() {
        let tree: AVLTree<Int> = [1, 5, 8, 7, 10, 15, 20, 17, 25]
        let input = 30
        let expected = 30

        tree.insert(value: input)

        XCTAssertEqual(tree.search(value: input)?.value, expected)
    }

    func testInsertLeftA() {
        let tree: AVLTree<String> = ["X", "Y", "Z"]
        let input = ["A", "B", "C"]
        let expected = (height: 3, balanced: true, present: ["A", "B", "C", "X", "Y", "Z"])

        for value in input {
            tree.insert(value: value)
        }

        XCTAssertEqual(tree.balanced, expected.balanced)
        XCTAssertEqual(tree.height, expected.height)
        for value in expected.present {
            XCTAssertNotNil(tree.search(value: value))
        }
    }

    func testInsertLeftnegative1() {
        let tree: AVLTree<String> = ["A", "B", "C"]
        let input = "-1"
        let expected = "-1"

        tree.insert(value: input)

        XCTAssertEqual(tree.search(value: input)?.value, expected)
    }

    func testInsertExisting8() {
        let tree: AVLTree<Int> = [1, 5, 8, 7, 10, 15, 20, 17, 25]
        let input = 8
        let expected = 8

        tree.insert(value: input)

        XCTAssertEqual(tree.search(value: input)?.value, expected)
    }

    func testDeleteNonExisting30() {
        let tree: AVLTree<Int> = [1, 5, 8, 7, 10, 15, 20, 17, 25]
        let input = 30
        let expected: Int? = nil

        tree.delete(value: input)

        XCTAssertEqual(tree.search(value: input)?.value, expected)
    }

    func testDeleteRoot1NodeTree() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1), value: 1)
        let expected: (height: Int, balanced: Bool, value: Int?) = (0, true, nil)

        input.tree.delete(value: input.value)

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)
        XCTAssertEqual(input.tree.search(value: input.value)?.value, expected.value)
    }

    func testDeleteRoot3NodeTree() {
        let input = (tree: AVLTree<String>(arrayLiteral: "C", "B", "A"), value: "B")
        let expected: (height: Int, balanced: Bool, value: String?) = (2, true, nil)

        input.tree.delete(value: input.value)

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)
        XCTAssertEqual(input.tree.search(value: input.value)?.value, expected.value)
    }

    func testDeleteExisting1() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [1])
        let expected = (height: 4, balanced: true, present: [5, 8, 7, 10, 15, 20, 17, 25], missing: [1])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExisting5() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [5])
        let expected = (height: 4, balanced: true, present: [1, 8, 7, 10, 15, 20, 17, 25], missing: [5])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExisting7() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [7])
        let expected = (height: 4, balanced: true, present: [1, 5, 8, 10, 15, 20, 17, 25], missing: [7])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExisting8() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [8])
        let expected = (height: 4, balanced: true, present: [1, 5, 7, 10, 15, 20, 17, 25], missing: [8])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExisting10() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [10])
        let expected = (height: 4, balanced: true, present: [1, 5, 8, 7, 15, 20, 17, 25], missing: [10])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingLeafNodesForceReBalance() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [1, 7, 10, 17, 25])
        let expected = (height: 3, balanced: true, present: [5, 8, 15, 20], missing: [1, 7, 10, 17, 25])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingLeafNodesNoReBalance() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [25, 17, 10, 7, 1])
        let expected = (height: 3, balanced: true, present: [5, 8, 15, 20], missing: [25, 17, 10, 7, 1])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingInnerNodes() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [5, 8, 20])
        let expected = (height: 3, balanced: true, present: [1, 7, 10, 15, 17, 25], missing: [5, 8, 20])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingSingleLeftNode() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [7, 5])
        let expected = (height: 3, balanced: true, present: [1, 8, 10, 15, 20, 17, 25], missing: [7, 5])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingAllBut3() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [5, 8, 7, 15, 20, 17])
        let expected = (height: 2, balanced: true, present: [1, 10, 25], missing: [5, 8, 7, 15, 20, 17])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingAllBut1() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [1, 5, 8, 7, 10, 15, 20, 17])
        let expected = (height: 1, balanced: true, present: [25], missing: [1, 5, 8, 7, 10, 15, 20, 17])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testDeleteExistingAll() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), values: [1, 5, 8, 7, 10, 15, 20, 17, 25])
        let expected = (height: 0, balanced: true, present: [] as [Int], missing: [1, 5, 8, 7, 10, 15, 20, 17, 25])

        for value in input.values {
            input.tree.delete(value: value)
        }

        XCTAssertEqual(input.tree.balanced, expected.balanced)
        XCTAssertEqual(input.tree.height, expected.height)

        for value in expected.present {
            XCTAssertNotNil(input.tree.search(value: value), "Expected value \(value) to be present but was missing.")
        }
        for value in expected.missing {
            XCTAssertNil(input.tree.search(value: value), "Expected value \(value) to be missing but was present.")
        }
    }

    func testSearchExisting1() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 1)
        let expected = 1

        XCTAssertEqual(input.tree.search(value: input.value)?.value, expected)
    }

    func testSearchExisting8() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 8)
        let expected = 8

        XCTAssertEqual(input.tree.search(value: input.value)?.value, expected)
    }

    func testSearchExisting25() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 25)
        let expected = 25

        XCTAssertEqual(input.tree.search(value: input.value)?.value, expected)
    }

    func testSearchNonExisting0() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 0)
        let expected: Int? = nil

        XCTAssertEqual(input.tree.search(value: input.value)?.value, expected)
    }

    func testSearchNonExisting30() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 30)
        let expected: Int? = nil

        XCTAssertEqual(input.tree.search(value: input.value)?.value, expected)
    }

    func testNextOf1() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 1)
        let expected = 5

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf7() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 7)
        let expected = 8

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf8() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 8)
        let expected = 10

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf10() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 10)
        let expected = 15

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf15() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 15)
        let expected = 17

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testNextOf25() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 25)
        let expected: Int? = nil

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.next(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\((expected != nil) ? String(describing: expected) : "nil")' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf1() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 1)
        let expected: Int? = nil

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\((expected != nil) ? String(describing: expected) : "nil")' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf8() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 8)
        let expected = 7

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf10() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 10)
        let expected = 8

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf15() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 15)
        let expected = 10

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    func testPreviousOf17() {
        let input = (tree: AVLTree<Int>(arrayLiteral: 1, 5, 8, 7, 10, 15, 20, 17, 25), value: 17)
        let expected = 15

        if let node = input.tree.search(value: input.value) {
            XCTAssertEqual(input.tree.previous(node: node)?.value, expected)
        } else {
            XCTFail("Expected value '\(expected)' not found in tree \(input.tree).")
        }
    }

    // MARK: - Performance measurements

    func testSearchPerformance() {

        let tree = { () -> AVLTree<Int> in
            let tree = AVLTree<Int>()

            /// Prime the tree with initial values
            for i in stride(from: 0, to: 64000, by: 2) {    /// 32,000 initial values in tree
                tree.insert(value: i)
            }
            return tree
        }()
        let input = stride(from: 0, to: 20000, by: 2) /// 10,000 iterations for the test matching stride of tree

        measure {
            for value in input {
                let _ = tree.search(value: value)
            }
        }
    }

    func testInsertPerformance() {

        let tree = { () -> AVLTree<Int> in
            let tree = AVLTree<Int>()
            ///
            /// Prime the tree with initial values
            /// Increment by 2 to allow room to insert using a stride starting at 1 for the input
            ///
            for i in stride(from: 0, to: 64000, by: 2) {    /// 32,000 initial values in tree
                tree.insert(value: i)
            }
            return tree
        }()
        let input = stride(from: 1, to: 20001, by: 2) /// 10,000 iterations for the test

        measure {
            for value in input {
                tree.insert(value: value)
            }
        }
    }

    func testDeletePerformance() {

        let tree = { () -> AVLTree<Int> in
            let tree = AVLTree<Int>()
            ///
            /// Prime the tree with initial values
            /// Increment by 2 to allow room to insert using a stride starting at 1 for the input
            ///
            for i in stride(from: 0, to: 64000, by: 2) {    /// 32,000 initial values in tree
                tree.insert(value: i)
            }
            return tree
        }()
        let input = stride(from: 0, to: 20000, by: 2) /// 10,000 iterations for the test

        measure {
            for value in input {
                tree.delete(value: value)
            }
        }
    }

    func testInsertDeleteBestTimePerformance() {

        let tree = { () -> AVLTree<Int> in
            return AVLTree<Int>()
        }()
        let input = (iterations: 0..<5000, values: [2, 1])  /// We have a total of 20,000 operations 5,000 x (2 inserts + 2 deletes)

        measure {
            for _ in input.iterations {
                for value in input.values {
                    tree.insert(value: value)
                }
                for value in input.values.reversed() {
                    tree.delete(value: value)
                }
            }
        }
    }

    func testInsertDeleteWorstTimePerformance() {

        let tree = { () -> AVLTree<Int> in
            let tree = AVLTree<Int>()
            ///
            /// Prime the tree with initial values
            /// Increment by 2 to allow room to insert using a stride starting at 1 for the input
            ///
            for i in stride(from: 0, to: 64000, by: 2) {    /// 32,000 initial values in tree
                tree.insert(value: i)
            }
            return tree
        }()
        let input = (iterations: 0..<5000, values: [63987, 63989])  /// We have a total of 20,000 operations 5,000 x (2 inserts + 2 deletes)

        measure {
            for _ in input.iterations {
                for value in input.values {
                    tree.insert(value: value)
                }
                for value in input.values.reversed() {
                    tree.delete(value: value)
                }
            }
        }
    }
}
