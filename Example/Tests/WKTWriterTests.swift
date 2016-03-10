/*
 *   WKTReaderTests
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
 *   Created by Paul Chang on 3/9/16.
 */

import XCTest
import GeoFeatures2

class WKTWriterTests: XCTestCase {
    
    private var wktWriter: WKTWriter<Coordinate2D>!
    
    override func setUp() {
        
        wktWriter = WKTWriter()
    }
    
    func testWrite_Point() {

        let wktStr = wktWriter.write(Point<Coordinate2D>(coordinate: (1.0, 1.0)))
        
        XCTAssertEqual("point (1.0 1.0)", wktStr)
    }
}