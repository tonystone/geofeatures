///
///  LinearRing+CurveTests.swift
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
///  Created by Tony Stone on 5/30/2016.
///
import XCTest
import GeoFeatures

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class LinearRingCurveCoordinate2DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testLengthTest1() {
        XCTAssertEqual(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0), (x: 1, y: 1)], precision: precision, coordinateSystem: cs).length(), 1.4142135623730951)
    }

    func testLengthTest2() {
        XCTAssertEqual(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0), (x: 0, y: 2)], precision: precision, coordinateSystem: cs).length(), 2.0)
    }

    func testLengthTest3() {
        XCTAssertEqual(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0), (x: 7, y:0)], precision: precision, coordinateSystem: cs).length(), 7.0)
    }

    func testLengthTest4() {
        XCTAssertEqual(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0), (x: 0, y: 2), (x: 0, y: 3), (x: 0, y: 4), (x: 0, y: 5)], precision: precision, coordinateSystem: cs).length(), 5.0)
    }

    func testLengthPerformance() {
        let lineString = LinearRing<Coordinate2D>(elements: [(x:0, y: 0), (x: 0, y: 2), (x: 0, y: 3), (x: 0, y: 4), (x: 0, y: 5)], precision: precision, coordinateSystem: cs)

        self.measure {

            for _ in 1...500000 {
                let _ = lineString.length()
            }
        }
    }

    func testIsClosedClosed() {
        XCTAssertTrue(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0), (x: 0, y: 2), (x: 0, y: 3), (x: 2, y: 0), (x: 0, y: 0)], precision: precision, coordinateSystem: cs).isClosed())
    }

    func testIsClosedOpen() {
        XCTAssertFalse(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0), (x: 0, y: 2), (x: 0, y: 3), (x: 0, y: 4), (x: 0, y: 5)], precision: precision, coordinateSystem: cs).isClosed())
    }

    func testIsClosedEmpty() {
        XCTAssertFalse(LinearRing<Coordinate2D>(precision: precision, coordinateSystem: cs).isClosed())
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class LinearRingCurveCoordinate3DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testPerformanceLength() {
        let lineString = LinearRing<Coordinate3D>(elements: [(x:0, y: 0, z: 0), (x: 0, y: 2, z: 0), (x: 0, y: 3, z: 0), (x: 0, y: 4, z: 0), (x: 0, y: 5, z:0)], precision: precision, coordinateSystem: cs)

        self.measure {

            for _ in 1...500000 {
                let _ = lineString.length()
            }
        }
    }
}
