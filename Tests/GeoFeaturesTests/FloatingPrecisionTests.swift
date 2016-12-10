///
///  FloatingPrecisionTests.swift
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
///  Created by Tony Stone on 2/11/2016.
///
import XCTest
import GeoFeatures

class FloatingPrecisionTests: XCTestCase {

    let precision  = FloatingPrecision()

    func testConvertEqual() {
        XCTAssertEqual(precision.convert(100.003), 100.003)
    }

    func testConvertNotEqual1() {
        XCTAssertNotEqual(precision.convert(100.0), 100.003)
    }

    func testConvertNotEqual2() {
        XCTAssertNotEqual(precision.convert(100.003), 100.0003)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {
        XCTAssertEqual(precision.description, "FloatingPrecision")
    }

    func testDebugDescription() {
        XCTAssertEqual(precision.debugDescription, "FloatingPrecision")
    }

    func testEqualTrue() {
        let input1 = FloatingPrecision()
        let input2 = FloatingPrecision()

        XCTAssertEqual(input1, input2)
    }

    func testEqualFalseWithDifferentType() {
        let input1 = FixedPrecision(scale: 10)
        let input2 = FloatingPrecision()

        XCTAssertFalse(input1 == input2)
    }
}
