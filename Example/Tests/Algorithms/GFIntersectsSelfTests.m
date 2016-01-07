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

    - (void) testIntersectsSelf_WithIntersectingBigPolygon {
        XCTAssertEqual([[[GFPolygon alloc] initWithWKT: @"POLYGON((-91.5494 42.0698,-91.5494 42.0698,-91.549 42.0698,-91.5489 42.0697,-91.5488 42.0696,-91.5485 42.0696,-91.5481 42.0695,-91.5477 42.0694,-91.5475 42.0694,-91.5474 42.0693,-91.5472 42.0692,-91.547 42.0691,-91.547 42.0685,-91.547 42.0684,-91.5468 42.0682,-91.5467 42.0682,-91.5465 42.0681,-91.5463 42.0679,-91.5462 42.0678,-91.5461 42.0677,-91.546 42.0675,-91.5457 42.0674,-91.5456 42.0673,-91.5456 42.0672,-91.5456 42.0671,-91.5456 42.067,-91.5457 42.0669,-91.5458 42.0668,-91.546 42.0667,-91.5463 42.0666,-91.5464 42.0665,-91.5465 42.0664,-91.5465 42.0663,-91.5465 42.066,-91.5464 42.0657,-91.5464 42.0656,-91.5464 42.0655,-91.5465 42.0654,-91.5466 42.0652,-91.5469 42.065,-91.547 42.065,-91.547 42.0649,-91.547 42.0648,-91.5468 42.0647,-91.5477 42.0647,-91.5499 42.0647,-91.5499 42.0649,-91.5498 42.0648,-91.5495 42.0648,-91.5493 42.0648,-91.5491 42.0649,-91.5489 42.065,-91.5486 42.065,-91.5484 42.065,-91.5483 42.0651,-91.5483 42.0652,-91.5483 42.0653,-91.5485 42.0654,-91.5487 42.0654,-91.5489 42.0654,-91.549 42.0654,-91.5491 42.0655,-91.5491 42.0656,-91.5491 42.0657,-91.549 42.0657,-91.5489 42.0658,-91.5486 42.0658,-91.5484 42.0658,-91.5483 42.0658,-91.5481 42.0659,-91.5479 42.0661,-91.5479 42.0662,-91.5479 42.0664,-91.548 42.0665,-91.5481 42.0666,-91.5482 42.0667,-91.5485 42.0667,-91.549 42.0668,-91.5491 42.0668,-91.5491 42.0668,-91.5489 42.0668,-91.5489 42.0668,-91.5489 42.0673,-91.549 42.0679,-91.5492 42.0696,-91.5494 42.0698))"] intersects], true);
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