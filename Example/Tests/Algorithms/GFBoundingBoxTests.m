/*
*   GFBoundingBoxTests.m
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

@interface GFBoundingBoxTests : XCTestCase
@end

bool closeAtTolerance (double left, double right, double tolerance);

#define BoundingBoxTest(T, wkt, x1, y1, x2, y2) XCTAssertTrue([self checkValidBoundingBox: ([[T alloc] initWithWKT: (wkt)]) minX: x1 minY: y1 maxX: x2 maxY: y2])

//
// Test Support
//
// Adapted from the C++ boost test classes
double safeDoubleDivision(double d1, double d2 )
{
    // Overflow.
    if( (d2 < (double) 1)  && (d1 > d2 * DBL_MAX) )
        return DBL_MAX;

    // Underflow.
    if( (d1 == (double) 0) || ((d2 > (double) 1) && (d1 < d2* DBL_MIN)) )
        return (double) 0;

    return d1/d2;
}

// Adapted from the C++ boost test classes
bool closeAtTolerance (double left, double right, double tolerance) {
    double diff = fabs( left - right );
    double d1   = safeDoubleDivision(diff, fabs(right));
    double d2   = safeDoubleDivision(diff, fabs(left));

    return (d1 <= fabs(tolerance) && d2 <= fabs(tolerance));
}

@implementation GFBoundingBoxTests

    - (BOOL) checkValidBoundingBox: (GFGeometry *) geometry minX: (double) minX minY: (double) minY maxX: (double) maxX maxY: (double) maxY {

        GFBox * boundingBox = [geometry boundingBox];

        GFPoint * minCorner = [boundingBox minCorner];
        GFPoint * maxCorner = [boundingBox maxCorner];

        if (!closeAtTolerance([minCorner x], minX, 0.001))  return false;
        if (!closeAtTolerance([minCorner y], minY, 0.001))  return false;
        if (!closeAtTolerance([maxCorner x], maxX, 0.001))  return false;
        if (!closeAtTolerance([maxCorner y], maxY, 0.001))  return false;

        return true;
    }

    - (void) testBoundingBox_WithPoint {
        BoundingBoxTest(GFPoint, @"POINT(1 1)", 1, 1, 1, 1);
    }

    - (void) testBoundingBox_WithBox {
        BoundingBoxTest(GFBox, @"BOX(1 1,3 3)", 1, 1, 3, 3);
    }

    - (void) testBoundingBox_WithLineString {
        BoundingBoxTest(GFLineString, @"LINESTRING(1 1,2 2)", 1,  1, 2, 2);
    }

    - (void) testBoundingBox_WithPolygon1 {
        BoundingBoxTest(GFPolygon, @"POLYGON((1 1,1 3,3 3,3 1,1 1))", 1, 1, 3, 3);
    }

    - (void) testBoundingBox_WithPolygon2 {
        BoundingBoxTest(GFPolygon, @"POLYGON((4 1,0 7,7 9,4 1))", 0, 1, 7, 9);
    }

    - (void) testBoundingBox_WithRing {
        BoundingBoxTest(GFRing, @"LINESTRING(1 1,1 3,3 3,3 1,1 1)", 1,  1, 3, 3);
    }

    - (void) testBoundingBox_WithGeometryCollection1 {
        BoundingBoxTest(GFGeometryCollection , @"GEOMETRYCOLLECTION(LINESTRING(1 1,1 3,3 3,3 1,1 1))", 1,  1, 3, 3);
    }

    - (void) testBoundingBox_WithGeometryCollection2 {
        BoundingBoxTest(GFGeometryCollection , @"GEOMETRYCOLLECTION(LINESTRING(1 1,1 3,3 3,3 1,1 1),POLYGON((1 1,1 3,3 3,3 1,1 1)))", 1,  1, 3, 3);
    }

    - (void) testBoundingBox_WithGeometryCollection3 {
        BoundingBoxTest(GFGeometryCollection , @"GEOMETRYCOLLECTION(LINESTRING(1 1,1 3,3 3,3 1,1 1),POLYGON((1 1,1 3,3 3,3 1,1 1)),POLYGON((4 1,0 7,7 9,4 1)))", 0,  1, 7, 9);
    }


    - (void) testBoundingBox_WithGeometryCollection4 {
        // NOTE: At the time this method was written, ReadWKT would not recurse and not create a GeometryCollection in a GeometryCollection
        XCTAssertTrue([self checkValidBoundingBox: ([[GFGeometryCollection alloc] initWithArray: @[
                [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(LINESTRING(1 1,1 3,3 3,3 1,1 1))"],
                [[GFPolygon alloc] initWithWKT: @"POLYGON((1 1,1 3,3 3,3 1,1 1))"],
                [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((4 1,0 7,7 9,4 1)))"]
                ]]) minX: 0 minY: 1 maxX: 7 maxY: 9]);

    }

@end


