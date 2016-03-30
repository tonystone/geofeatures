//
//  AreaTest.swift
//  GeoFeatures2
//
//  Created by Tony Stone on 3/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

class Polygon_SurfaceTests: XCTestCase {

    let fixed = FixedPrecision(scale: 100000)
    
    // MARK: Coordinate2D
    // MARK: FixedPrecision
    // MARK: Cartesian
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_Empty() {
        XCTAssertEqual(Polygon<Coordinate2D>(precision: fixed).area(), 0.0)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_Triangle() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 2.96, y: 5.15), (x: 9.33, y: 7.62), (x: 8.29, y: 0.88)],[]), precision:  fixed).area(), 20.1825)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_RegularQuadrilateral() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 3.18, y: 3.12), (x: 5.43, y: 8.22), (x: 10.53, y: 5.98), (x: 8.29, y: 0.88)],[]), precision: fixed).area(), 31.0643)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_SimplePolygon1() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 0.72, y: 2.28), (x: 2.66, y: 4.71), (x: 5.0, y: 3.5), (x: 3.63, y: 2.52), (x: 4.0, y: 1.6), (x: 1.9, y: 1.0), (x: 0.72, y: 2.28)],[]), precision: fixed).area(), 8.3593)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_SimplePolygon2() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 7), (x: 4, y: 2), (x: 2, y: 0), (x: 0, y: 0)],[]), precision: fixed).area(), 16.0)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_SimplePolygon3() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 6), (x: 6, y: 6), (x: 6, y: 0), (x: 0, y: 0)],[]), precision: fixed).area(), 36.0)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_SimplePolygon_WithHole() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 6), (x: 6, y: 6), (x: 6, y: 0), (x: 0, y: 0)],[[(x: 1, y: 1), (x: 4, y: 1), (x: 4, y: 2), (x: 1, y: 2), (x: 1, y: 1)]]), precision: fixed).area(), 33.0)
    }

    func testArea_Coordinate2D_FixedPrecision_Cartesian_Pentagon() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 7.61, y: 4.86), (x: 1.53, y: 3.60), (x: 7.86, y: 8.36), (x: 10.79, y: 4.77), (x: 8.29, y: 0.88)],[]), precision: fixed).area(), 22.35635)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_RegularPentagon() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 3.81, y: 2.06), (x: 3.54, y: 6.68), (x: 7.86, y: 8.36), (x: 10.79, y: 4.77), (x: 8.29, y: 0.88)],[]), precision: fixed).area(), 36.89385)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_RegularDecagon() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 5.85, y: 0.74), (x: 3.81, y: 2.06), (x: 2.92, y: 4.33), (x: 3.54, y: 6.68), (x: 5.43, y: 8.22), (x: 7.86, y: 8.36), (x: 9.91, y: 7.04), (x: 10.79, y: 4.77), (x: 10.17, y: 2.42), (x: 8.29, y: 0.88)],[]), precision: fixed).area(), 45.61285)
    }
    
    func testArea_Coordinate2D_FixedPrecision_Cartesian_Tetrakaidecagon() {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 8.32, y: 1.66), (x: 6.55, y: 0.62), (x: 4.88, y: 1.14), (x: 8.32, y: 2.95), (x: 2.96, y: 3.98), (x: 7.04, y: 6.15), (x: 7.24, y: 7.20), (x: 5.43, y: 8.22), (x: 7.17, y: 8.48), (x: 8.84, y: 7.96), (x: 6.65, y: 4.32), (x: 10.76, y: 5.12), (x: 8.87, y: 4.06), (x: 9.74, y: 1.86), (x: 8.32, y: 1.66)],[]), precision: fixed).area(), 18.63)
    }

    func testArea_Coordinate2D_FixedPrecision_Cartesian_RegularQuadrilateral_CrossingOrigin () {
        XCTAssertEqual(Polygon<Coordinate2D>(rings: ([(x: 1.00, y: -1.00), (x: -1.00, y: -1.00), (x: -1.00, y: 1.00), (x: 1.00, y: 1.00), (x: 1.00, y: -1.00)], []), precision: fixed).area(), 4.0)
    }
    
    func testPerformanceArea_Coordinate2D_FixedPrecision_Cartesian_Quadrilateral() {
        let geometry = Polygon<Coordinate2D>(rings: ([(x: 8.29, y: 0.88), (x: 3.18, y: 3.12), (x: 5.43, y: 8.22), (x: 10.53, y: 5.98), (x: 8.29, y: 0.88)], []), precision: fixed)
        
        self.measureBlock {
            
            for _ in 1...500000 {
                let _ = geometry.area()
            }
        }
    }
    
}
