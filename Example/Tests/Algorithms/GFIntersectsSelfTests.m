/*
*   GFIntersectsSelfTests.m
*
*   Copyright 2015 Tony Stone
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
*   Created by Tony Stone on 10/7/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFIntersectsSelfTests : XCTestCase
@end

@implementation GFIntersectsSelfTests


    - (void) testIntersectsSelf_WithPoint {
        XCTAssertEqual([[[GFPoint alloc] initWithWKT: @"POINT(0 0)"] intersects], false);
    }

    - (void) testIntersectsSelf_WithEmptyPoint {
        XCTAssertEqual([[[GFPoint alloc] initWithWKT: @"POINT EMPTY"] intersects], false);
    }

    - (void) testIntersectsSelf_WithNonIntersectingMultiPoint {
        XCTAssertEqual([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT(0 0,1 1)"] intersects], false);
    }

    - (void) testIntersectsSelf_WithEmptyMultiPoint {
        XCTAssertEqual([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT EMPTY"] intersects], false);
    }

    - (void) testIntersectsSelf_WithIntersectingLineString {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,0 4,4 4,2 2,2 5)"] intersects], true);
    }

    - (void) testIntersectsSelf_WithEmptyLineString {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING EMPTY"] intersects], false);
    }

    - (void) testIntersectsSelf_WithIntersectingMultiLineString {
        XCTAssertEqual([[[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((0 0,0 4,4 4,2 2,2 5),(0 4,4 4,2 2,2 5))"] intersects], true);
    }

    - (void) testIntersectsSelf_WithEmptyMultiLineString {
        XCTAssertEqual([[[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING EMPTY"] intersects], false);
    }

    - (void) testIntersectsSelf_WithIntersectingPolygon {
        XCTAssertEqual([[[GFPolygon alloc] initWithWKT: @"POLYGON((0 2,2 4,2 0,4 2,0 2))"] intersects], true);
    }

    - (void) testIntersectsSelf_WithEmptyPolygon {
        XCTAssertEqual([[[GFPolygon alloc] initWithWKT: @"POLYGON EMPTY"] intersects], false);
    }

    - (void) testIntersectsSelf_WithSimpleRing {
        XCTAssertEqual([[[GFRing alloc] initWithWKT: @"LINESTRING(0 4,4 4,2 2,2 5)"] intersects], true);
    }

    - (void) testIntersectsSelf_WithEmptyRing {
        XCTAssertEqual([[[GFRing alloc] initWithWKT: @"LINESTRING EMPTY"] intersects], false);
    }

    - (void) testIntersectsSelf_WithBox {
        XCTAssertEqual([[[GFBox alloc] initWithWKT: @"BOX(1 1,3 3)"] intersects], false);
    }

@end