/*
*   GFCentroidTests.m
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
*   Created by Tony Stone on 04/14/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFCentroidTests : XCTestCase
@end

#define CentroidTest(T,input,expected) XCTAssertEqualObjects([[[[T alloc] initWithWKT: (input)] centroid] toWKTString], (expected))

@implementation GFCentroidTests

    - (void) testCentroid_WithPoint {
        CentroidTest(GFPoint, @"POINT(1 1)", @"POINT(1 1)");
    }

    - (void) testCentroid_WithMultiPoint {
        CentroidTest(GFMultiPoint, @"MULTIPOINT (-1 0,-1 2,-1 3,-1 4,-1 7,0 1,0 3,1 1,2 0,6 0,7 8,9 8,10 6)", @"POINT(2.30769 3.30769)");
    }

    - (void) testCentroid_WithPolygon {
        CentroidTest(GFPolygon, @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                     "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", @"POINT(4.04663 1.6349)");
    }

    - (void) testCentroid_WithRing {
        CentroidTest(GFRing, @"LINESTRING(2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)", @"POINT(4.06923 1.65056)");
    }

    - (void) testCentroid_Empty_Polygon {
        XCTAssertThrowsSpecificNamed([[[GFPolygon alloc] initWithWKT: @"POLYGON()"] centroid], NSException, @"Exception");
    }


@end