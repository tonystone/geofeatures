/*
*   GFGeometryTests.m
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
*   Created by Tony Stone on 09/07/2015.
*/
#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFGeometryTests : XCTestCase
@end

//
// Open up the protected methods in GFGeometry for testing.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@interface GFGeometry (Test)
    - (instancetype) initWithWKT: (NSString *) wkt;
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;
@end
#pragma clang diagnostic pop

//
// Internal test class
//
@interface GFGeometryTestSubClass : GFGeometry
@end
@implementation GFGeometryTestSubClass
    - (instancetype) init {
        return self;
    }
@end


#define GeometryWithWKTTest(wkt)              XCTAssertEqualObjects([[GFGeometry geometryWithWKT: (wkt)] toWKTString], [(wkt) uppercaseString])
#define GeometryWithWKTTest2(wkt,expectedWKT) XCTAssertEqualObjects([[GFGeometry geometryWithWKT: (wkt)] toWKTString], [(expectedWKT) uppercaseString])

#define EncodingTest(wkt) XCTAssertEqualObjects([self encodeDecode: [GFGeometry geometryWithWKT: (wkt)]], (wkt))


@implementation GFGeometryTests

    - (void)testFailedConstruction {
        XCTAssertThrowsSpecificNamed([[GFGeometry alloc] init], NSException, NSInternalInconsistencyException);
        XCTAssertThrowsSpecificNamed([[GFGeometryTestSubClass alloc] initWithWKT: nil], NSException, NSInternalInconsistencyException);
        XCTAssertThrowsSpecificNamed([[GFGeometryTestSubClass alloc] initWithGeoJSONGeometry: nil], NSException, NSInternalInconsistencyException);

        XCTAssertThrowsSpecificNamed(([GFGeometry geometryWithGeoJSONGeometry: @{@"type" : @"Invalid", @"invalid" : @[@(103.0), @(2.0)]}]), NSException, NSInvalidArgumentException);
    }

    - (void) testGeometryWithGeoJSONGeometry {
        XCTAssertEqualObjects(([[GFGeometry geometryWithGeoJSONGeometry: @{@"type" : @"Point", @"coordinates" : @[@(103.0), @(2.0)]}] toWKTString]), @"POINT(103 2)");
    }

    - (void) testGeometryWithWKT {
        GeometryWithWKTTest (@"POINT(1 1)");
        GeometryWithWKTTest2(@"POINT()", @"POINT(0 0)");
        GeometryWithWKTTest2(@"POINT EMPTY", @"POINT(0 0)");

        GeometryWithWKTTest (@"MULTIPOINT((1 1),(2 2))");
        GeometryWithWKTTest (@"MULTIPOINT()");
        GeometryWithWKTTest2(@"MULTIPOINT EMPTY", @"MULTIPOINT()");

        GeometryWithWKTTest (@"LINESTRING(40 60,120 110)");
        GeometryWithWKTTest (@"LINESTRING()");
        GeometryWithWKTTest2(@"LINESTRING EMPTY", @"LINESTRING()");

        GeometryWithWKTTest (@"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))");
        GeometryWithWKTTest (@"MULTILINESTRING()");
        GeometryWithWKTTest2(@"MULTILINESTRING EMPTY", @"MULTILINESTRING()");

        GeometryWithWKTTest (@"POLYGON((0 0,0 90,90 90,90 0,0 0))");
        GeometryWithWKTTest2(@"POLYGON()", @"POLYGON(())");
        GeometryWithWKTTest2(@"POLYGON EMPTY", @"POLYGON(())");

        GeometryWithWKTTest (@"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
        GeometryWithWKTTest (@"MULTIPOLYGON()");
        GeometryWithWKTTest2(@"MULTIPOLYGON EMPTY", @"MULTIPOLYGON()");

        GeometryWithWKTTest (@"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
        GeometryWithWKTTest (@"GEOMETRYCOLLECTION()");
        GeometryWithWKTTest2(@"GEOMETRYCOLLECTION EMPTY", @"GEOMETRYCOLLECTION()");
    }


    - (NSString *) encodeDecode: (GFGeometry *) inputGeometry {

        NSMutableData * archive = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archive];

        [archiver encodeObject:inputGeometry];
        [archiver finishEncoding];

        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archive];
        GFGeometry * resultGeometry = [unarchiver decodeObject];

        return [resultGeometry toWKTString];
    }

    - (void) testEncode {
        EncodingTest(@"POINT(1 1)");
        EncodingTest(@"MULTIPOINT((1 1),(2 2))");
        EncodingTest(@"LINESTRING(40 60,120 110)");
        EncodingTest(@"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))");
        EncodingTest(@"POLYGON((0 0,0 90,90 90,90 0,0 0))");
        EncodingTest(@"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
        EncodingTest(@"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }

    - (void) testCopy {
    
        GFGeometry * geometry = [GFGeometry geometryWithWKT: @"POINT(1 1)"];
        
        XCTAssertEqualObjects([[geometry copy] toWKTString], @"POINT(1 1)");
    }

    - (void) testOverriddenMethods {
        XCTAssertThrowsSpecificNamed([[[GFGeometryTestSubClass alloc] init] toGeoJSONGeometry], NSException, NSInternalInconsistencyException);
        XCTAssertThrowsSpecificNamed([[[GFGeometryTestSubClass alloc] init] mkMapOverlays], NSException, NSInternalInconsistencyException);
    }

@end