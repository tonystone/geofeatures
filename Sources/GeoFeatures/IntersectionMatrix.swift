///
///  IntersectionMatrix.swift
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
///  Created by Tony Stone on 5/8/2016.
///
import Swift

///
/// Implementation of the Dimensionally Extended Nine-Intersection Model (DE-9IM)
///
/// The intersection of two of either I(x), B(x), and E(x) will result in various combinations of geometry objects each with possibly different dimensions.
///
/// - dim(x) == Returns the maximum dimension (-1, 0, 1, 2) of the result geometries of an intersection. See `Dimension` for more information.
/// - I(x)   == Interior of geometry x
/// - B(x)   == Boundary of geometry x
/// - E(x)   == Exterior of geometry x
///
/// The table below shows the general form of the matrix.
///
/// ```
/// |-------------|------------------|------------------|------------------|
/// |             |  INTERIOR        |  BOUNDARY        |  EXTERIOR        |
/// |-------------|------------------|------------------|------------------|
/// | INTERIOR    | dim(I(a) ∩ I(b)) | dim(I(a) ∩ B(b)) | dim(I(a) ∩ E(b)) |
/// |-------------|------------------|------------------|------------------|
/// | BOUNDARY    | dim(B(a) ∩ I(b)) | dim(B(a) ∩ B(b)) | dim(B(a) ∩ E(b)) |
/// |-------------|------------------|------------------|------------------|
/// | EXTERIOR    | dim(E(a) ∩ I(b)) | dim(E(a) ∩ B(b)) | dim(E(a) ∩ E(b)) |
/// |-------------|------------------|------------------|------------------|
/// ```
///
internal struct IntersectionMatrix {

    enum Index: Int { case interior = 0, boundary, exterior }

    fileprivate
    var matrix: [[Dimension]]
}

///
/// IntersectionMatrix Construction
///
extension IntersectionMatrix {

    ///
    /// Initialize an IntersectionMatrix with the default values of .empty
    ///
    internal init() {
        self.matrix =
            [
                [.empty, .empty, .empty],
                [.empty, .empty, .empty],
                [.empty, .empty, .empty]
            ]
    }

    ///
    /// Initialize an IntersectionMatrix with an Array of Arrays of
    /// of Dimension values.
    ///
    /// - Parameter: arrayLiteral: [[Dimension]] Array of `Dimension` arrays.
    ///
    /// - Requires: arrayLiteral.count == 3
    /// - Requires: arrayLiteral[0].count == 3
    /// - Requires: arrayLiteral[1].count == 3
    /// - Requires: arrayLiteral[2].count == 3
    ///
    internal init(arrayLiteral elements: [[Dimension]]) {
        assert( elements.count == 3 &&
                elements[Index.interior.rawValue].count == 3 &&
                elements[Index.boundary.rawValue].count == 3 &&
                elements[Index.exterior.rawValue].count == 3
        )
        self.matrix = elements
    }
}

extension IntersectionMatrix {

    ///
    /// Match an IntersectionMatrix to a pattern matrix
    /// such as “T*T***T**”
    ///
    /// Pattern Values:
    /// - T: matches when dim(x) ∈ {0, 1, 2}, i.e. x ≠ ∅
    /// - F: matches when dim(x) = -1, i.e. x = ∅
    /// - *: Matches when dim(x) ∈ {-1, 0, 1, 2}, i.e. Don’t Care
    /// - 0: Matches when dim(x) = 0
    /// - 1: Matches when dim(x) = 1
    /// - 2: Matches when dim(x) = 2
    ///
    /// - parameter pattern: The pattern string consisting of legal characters from the set above.
    ///
    internal func matches(_ pattern: String) -> Bool {

        var characters = pattern.characters.makeIterator()

        for row in 0...Index.exterior.rawValue {
            for col in 0...Index.exterior.rawValue {
                if let character = characters.next() {

                    switch character {

                    case "T":

                        if ![Dimension.zero, .one, .two].contains(self.matrix[row][col]) {
                            return false
                        }
                        continue
                    case "F":

                        if Dimension.empty != self.matrix[row][col] {
                            return false
                        }
                        continue
                    case "*":
                        /// All are valid
                        continue
                    case "0":

                        if Dimension.zero != self.matrix[row][col] {
                            return false
                        }
                        continue
                    case "1":

                        if Dimension.one != self.matrix[row][col] {
                            return false
                        }
                        continue
                    case "2":

                        if Dimension.two != self.matrix[row][col] {
                            return false
                        }
                        continue
                    default:
                        return false    // Invalid character passed
                    }

                } else {
                    return false  // Pattern is too short so it does not match
                }
            }
        }
        return true
    }
}

///
/// Sequence support for IntersectionMatrix
///
extension IntersectionMatrix: Sequence {

    ///
    /// subscript the matrix returning a `Dimension` type
    ///
    /// - Parameters:
    /// - row: the row in the matrix expressed as an Index value.
    /// - col: the column in the matrix expressed as an Index value.
    ///
    /// Example:
    /// ```
    ///    let matrix = IntersectionMatrix()
    ///
    ///    let dimension = matrix[.interior, .boundary]
    ///
    ///    matrix[.interior, .boundary] = .two
    /// ```
    ///
    internal subscript (row: Index, col: Index) -> Dimension {

        get {
            return matrix[row.rawValue][col.rawValue]
        }
        set (newValue) {
            matrix[row.rawValue][col.rawValue] = newValue
        }
    }

    ///
    /// IntersectionMatrix is a sequence that can be iterated on.
    ///
    /// Example:
    /// ```
    ///    let matrix = IntersectionMatrix()
    ///
    ///    for value in matrix {
    ///        print("\(value)")
    ///    }
    /// ```
    ///
    internal func makeIterator() -> AnyIterator<Dimension> {

        /// keep the index of the next element in the iteration
        var nextRow = Index.interior.rawValue
        var nextCol = Index.interior.rawValue - 1

        /// Construct a AnyGenerator<Dimension> instance, passing a closure that returns the next element in the iteration
        return AnyIterator<Dimension> {

            if nextCol + 1 <= Index.exterior.rawValue {     /// New col
                nextCol += 1                                /// Increment column
            } else {
                if nextRow + 1 <= Index.exterior.rawValue { /// New row
                    nextRow += 1                            /// Increment row and
                    nextCol = Index.interior.rawValue       /// reset column
                } else {
                    return nil                              /// End of Matrix
                }
            }
            return self.matrix[nextRow][nextCol]
        }
    }
}

extension IntersectionMatrix: CustomStringConvertible {

    internal var description: String {
        var string = ""

        for dimension in self {
            if string.characters.count > 0 {
                string += ", "
            }
            string += "\(dimension.rawValue)"
        }
        return string
    }
}

extension IntersectionMatrix: Equatable {}

internal func == (lhs: IntersectionMatrix, rhs: IntersectionMatrix) -> Bool {

    for row in 0...IntersectionMatrix.Index.exterior.rawValue {
        for col in 0...IntersectionMatrix.Index.exterior.rawValue {

            if lhs.matrix[row][col] != rhs.matrix[row][col] {
                return false
            }
        }
    }
    return true
}
