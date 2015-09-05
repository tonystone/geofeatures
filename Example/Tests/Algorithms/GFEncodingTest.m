/*
*   GFEncodingTest.m
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

@interface GFEncodingTest : XCTestCase
@end

#define EncodingTest(wkt) XCTAssertEqualObjects([self encodeDecodeWithWKT: (wkt)], (wkt))

@implementation GFEncodingTest

    - (NSString *) encodeDecodeWithWKT: (NSString *) wkt {
        
        GFGeometry *inputGeometry = [GFGeometry geometryWithWKT: wkt];
        
        NSMutableData * archive = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archive];
        
        [archiver encodeObject:inputGeometry];
        [archiver finishEncoding];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archive];
        GFGeometry * resultGeometry = [unarchiver decodeObject];
        
        return [resultGeometry toWKTString];
    }

    - (void) testPoint {
        EncodingTest(GFPoint, @"POINT(1 1)");
    }

    - (void) testMultiPoint {
        EncodingTest(GFMultiPoint, @"MULTIPOINT((1 1),(2 2))");
    }

    - (void) testLineString {
        EncodingTest(GFLineString, @"LINESTRING(40 60,120 110)");
    }

    - (void) testMultiLineString {
        EncodingTest(GFMultiLineString, @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))");
    }

    - (void) testPolygon {
        EncodingTest(GFPolygon, @"POLYGON((0 0,0 90,90 90,90 0,0 0))");
    }

    - (void) testMultiPolygon {
        EncodingTest(GFMultiPolygon, @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testGeometryCollection {
        EncodingTest(GFGeometryCollection, @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }
//
//    - (void) testRing {
//        EncodingTest(GFRing, @"LINESTRING(0 0,0 90,90 90,90 0,0 0)");
//    }


@end