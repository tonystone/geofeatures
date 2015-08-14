//
//  GeoFeaturesTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 04/14/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFBoundingBoxTests : XCTestCase
@end

bool closeAtTolerance (double left, double right, double tolerance);

#define BoundingBoxTest(wkt, x1, y1, x2, y2) XCTAssertTrue([self checkValidBoundingBox: (wkt) minX: x1 minY: y1 maxX: x2 maxY: y2])

@implementation GFBoundingBoxTests

    - (BOOL) checkValidBoundingBox: (NSString *) wkt minX: (double) minX minY: (double) minY maxX: (double) maxX maxY: (double) maxY {
        GFGeometry * geometry = [GFGeometry geometryWithWKT: wkt];

        GFBox * boundingBox = [geometry boundingBox];

        GFPoint * minCorner = [boundingBox minCorner];
        GFPoint * maxCorner = [boundingBox maxCorner];

        if (!closeAtTolerance([minCorner x], minX, 0.001))  return false;
        if (!closeAtTolerance([minCorner y], minY, 0.001))  return false;
        if (!closeAtTolerance([maxCorner x], maxX, 0.001))  return false;
        if (!closeAtTolerance([maxCorner y], maxY, 0.001))  return false;

        return true;
    }

    - (void) testPoint {
        BoundingBoxTest(@"POINT(1 1)", 1, 1, 1, 1);
    }

    - (void) testBox {
        BoundingBoxTest(@"BOX(1 1,3 3)", 1, 1, 3, 3);
    }

    - (void) testLineString {
        BoundingBoxTest(@"LINESTRING(1 1,2 2)", 1,  1, 2, 2);
    }

    - (void) testPolygon {
        BoundingBoxTest(@"POLYGON((1 1,1 3,3 3,3 1,1 1))", 1, 1, 3, 3);
        BoundingBoxTest(@"POLYGON((4 1,0 7,7 9,4 1))", 0, 1, 7, 9);
    }

@end

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
