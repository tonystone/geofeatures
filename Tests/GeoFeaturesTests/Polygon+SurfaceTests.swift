///
///  Polygon+SurfaceTests.swift
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
///  Created by Tony Stone on 3/28/2016.
///
import XCTest
import GeoFeatures

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// TODO: Remove this after figuring out why there seems to be a symbol conflict (error: cannot specialize a non-generic definition) with another Polygon on Swift PM on Apple platforms only.
    import struct GeoFeatures.Polygon
#endif

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class PolygonSurfaceCoordinate2DFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100000)
    let cs       = Cartesian()

    func testAreaEmpty() {
        XCTAssertEqual(Polygon<Coordinate2D>(precision: precision, coordinateSystem: cs).area(), 0.0)
    }

    func testAreaWithTriangle() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 2.96, y: 5.15), (x: 9.33, y: 7.62), (x: 8.29, y: 0.88)], []), precision: precision, coordinateSystem: cs).area(), 20.1825)
    }

    func testAreaWithRegularQuadrilateral() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 3.18, y: 3.12), (x: 5.43, y: 8.22), (x: 10.53, y: 5.98), (x: 8.29, y: 0.88)], []), precision: precision, coordinateSystem: cs).area(), 31.0643)
    }

    func testAreaWithSimplePolygon1() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 0.72, y: 2.28), (x: 2.66, y: 4.71), (x: 5.0, y: 3.5), (x: 3.63, y: 2.52), (x: 4.0, y: 1.6), (x: 1.9, y: 1.0), (x: 0.72, y: 2.28)], []), precision: precision, coordinateSystem: cs).area(), 8.3593)
    }

    func testAreaWithSimplePolygon2() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 7), (x: 4, y: 2), (x: 2, y: 0), (x: 0, y: 0)], []), precision: precision, coordinateSystem: cs).area(), 16.0)
    }

    func testAreaWithSimplePolygon3() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 6), (x: 6, y: 6), (x: 6, y: 0), (x: 0, y: 0)], []), precision: precision, coordinateSystem: cs).area(), 36.0)
    }

    func testAreaWithSimplePolygonWithHole() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 6), (x: 6, y: 6), (x: 6, y: 0), (x: 0, y: 0)], [[(x: 1, y: 1), (x: 4, y: 1), (x: 4, y: 2), (x: 1, y: 2), (x: 1, y: 1)]]), precision: precision, coordinateSystem: cs).area(), 33.0)
    }

    func testAreaWithPentagon() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 7.61, y: 4.86), (x: 1.53, y: 3.60), (x: 7.86, y: 8.36), (x: 10.79, y: 4.77), (x: 8.29, y: 0.88)], []), precision: precision, coordinateSystem: cs).area(), 22.35635)
    }

    func testAreaWithRegularPentagon() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 3.81, y: 2.06), (x: 3.54, y: 6.68), (x: 7.86, y: 8.36), (x: 10.79, y: 4.77), (x: 8.29, y: 0.88)], []), precision: precision, coordinateSystem: cs).area(), 36.89385)
    }

    func testAreaWithRegularDecagon() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 5.85, y: 0.74), (x: 3.81, y: 2.06), (x: 2.92, y: 4.33), (x: 3.54, y: 6.68), (x: 5.43, y: 8.22), (x: 7.86, y: 8.36), (x: 9.91, y: 7.04), (x: 10.79, y: 4.77), (x: 10.17, y: 2.42), (x: 8.29, y: 0.88)], []), precision: precision, coordinateSystem: cs).area(), 45.61285)
    }

    func testAreaWithTetrakaidecagon() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.32, y: 1.66), (x: 6.55, y: 0.62), (x: 4.88, y: 1.14), (x: 8.32, y: 2.95), (x: 2.96, y: 3.98), (x: 7.04, y: 6.15), (x: 7.24, y: 7.20), (x: 5.43, y: 8.22), (x: 7.17, y: 8.48), (x: 8.84, y: 7.96), (x: 6.65, y: 4.32), (x: 10.76, y: 5.12), (x: 8.87, y: 4.06), (x: 9.74, y: 1.86), (x: 8.32, y: 1.66)], []), precision: precision, coordinateSystem: cs).area(), 18.63)
    }

    func testAreaWithRegularQuadrilateralCrossingOrigin () {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 1.00, y: -1.00), (x: -1.00, y: -1.00), (x: -1.00, y: 1.00), (x: 1.00, y: 1.00), (x: 1.00, y: -1.00)], []), precision: precision, coordinateSystem: cs).area(), 4.0)
    }

    func testPerformanceAreaQuadrilateral() {
        let geometry = Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 3.18, y: 3.12), (x: 5.43, y: 8.22), (x: 10.53, y: 5.98), (x: 8.29, y: 0.88)], []), precision: precision, coordinateSystem: cs)

        self.measure {

            for _ in 1...500000 {
                let _ = geometry.area()
            }
        }
    }
}
