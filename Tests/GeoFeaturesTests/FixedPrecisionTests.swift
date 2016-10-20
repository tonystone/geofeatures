/*
 *   FixedPrecisionTests.swift
 *
 *   Copyright 2016 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 2/11/16.
 */
import XCTest

import GeoFeatures

class FixedPrecisionTests: XCTestCase {

    let precision  = FixedPrecision(scale: 10)
    
    func testConvert_Scale10_Lower() {
        XCTAssertEqual(precision.convert(1.01), 1.0)
    }
    
    func testConvert_Scale10_Middle() {
        XCTAssertEqual(precision.convert(1.05), 1.1)
    }
    
    func testConvert_Scale10_Upper() {
        XCTAssertEqual(precision.convert(1.09), 1.1)
    }
    
    func testConvert_Scale10_Lower2() {
        XCTAssertEqual(precision.convert(1.0111), 1.0)
    }
    
    func testConvert_Scale10_Middle2() {
        XCTAssertEqual(precision.convert(1.0555), 1.1)
    }
    
    func testConvert_Scale10_Upper2() {
        XCTAssertEqual(precision.convert(1.0999), 1.1)
    }
}
