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

#pragma mark - Test init

    - (void)testInit {
        XCTAssertThrowsSpecificNamed([[GFGeometry alloc] init], NSException, NSInternalInconsistencyException);
    }

#pragma mark - Test initWithWKT

    - (void)testInitWithWKT {
        XCTAssertThrowsSpecificNamed([[GFGeometryTestSubClass alloc] initWithWKT: nil], NSException, NSInternalInconsistencyException);
    }

#pragma mark - Test initWithGeoJSONGeometry

    - (void)testInitWithGeoJSONGeometry_WithNil {
        XCTAssertThrowsSpecificNamed([[GFGeometryTestSubClass alloc] initWithGeoJSONGeometry: nil], NSException, NSInternalInconsistencyException);
    }

    - (void)testInitWithGeoJSONGeometry_WithInvalidGeoJSON {
        XCTAssertThrowsSpecificNamed(([GFGeometry geometryWithGeoJSONGeometry: @{@"type" : @"Invalid", @"invalid" : @[@(103.0), @(2.0)]}]), NSException, NSInvalidArgumentException);
    }

#pragma mark - Test geometryWithGeoJSONGeometry

    - (void) testGeometryWithGeoJSONGeometry_WithPoint {
        XCTAssertEqualObjects(([[GFGeometry geometryWithGeoJSONGeometry: @{@"type" : @"Point", @"coordinates" : @[@(103.0), @(2.0)]}] toWKTString]), @"POINT(103 2)");
    }

#pragma mark - Test geometryWithWKT

    - (void) testGeometryWithWKT_WithPoint {
        GeometryWithWKTTest (@"POINT(1 1)");
    }

    - (void) testGeometryWithWKT_WithEmptyPoint1 {
        GeometryWithWKTTest2(@"POINT()", @"POINT(0 0)");
    }

    - (void) testGeometryWithWKT_WithEmptyPoint2 {
        GeometryWithWKTTest2(@"POINT EMPTY", @"POINT(0 0)");
    }

    - (void) testGeometryWithWKT_WithMultiPoint {
        GeometryWithWKTTest (@"MULTIPOINT((1 1),(2 2))");
    }

    - (void) testGeometryWithWKT_WithEmptyMultiPoint1 {
        GeometryWithWKTTest (@"MULTIPOINT()");
    }

    - (void) testGeometryWithWKT_WithEmptyMultiPoint2 {
        GeometryWithWKTTest2(@"MULTIPOINT EMPTY", @"MULTIPOINT()");
    }

    - (void) testGeometryWithWKT_WithLineString {
        GeometryWithWKTTest (@"LINESTRING(40 60,120 110)");
    }

    - (void) testGeometryWithWKT_WithEmptyLineString1 {
        GeometryWithWKTTest (@"LINESTRING()");
    }

    - (void) testGeometryWithWKT_WithEmptyLineString2 {
        GeometryWithWKTTest2(@"LINESTRING EMPTY", @"LINESTRING()");
    }

    - (void) testGeometryWithWKT_WithMultiLineString {
        GeometryWithWKTTest (@"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))");
    }

    - (void) testGeometryWithWKT_WithEmptyMultiLineString1 {
        GeometryWithWKTTest (@"MULTILINESTRING()");
    }

    - (void) testGeometryWithWKT_WithEmptyMultiLineString2 {
        GeometryWithWKTTest2(@"MULTILINESTRING EMPTY", @"MULTILINESTRING()");
    }

    - (void) testGeometryWithWKT_WithPolygon {
        GeometryWithWKTTest (@"POLYGON((0 0,0 90,90 90,90 0,0 0))");
    }

    - (void) testGeometryWithWKT_WithEmptyPolygon1 {
        GeometryWithWKTTest2(@"POLYGON()", @"POLYGON(())");
    }

    - (void) testGeometryWithWKT_WithEmptyPolygon2 {
        GeometryWithWKTTest2(@"POLYGON EMPTY", @"POLYGON(())");
    }

    - (void) testGeometryWithWKT_WithMultiPolygon {
        GeometryWithWKTTest (@"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testGeometryWithWKT_WithEmptyMultiPolygon1 {
        GeometryWithWKTTest (@"MULTIPOLYGON()");
    }

    - (void) testGeometryWithWKT_WithEmptyMultiPolygon2 {
        GeometryWithWKTTest2(@"MULTIPOLYGON EMPTY", @"MULTIPOLYGON()");
    }

    - (void) testGeometryWithWKT_WithGeometryCollection {
        GeometryWithWKTTest (@"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }

    - (void) testGeometryWithWKT_WithEmptyGeometryCollection1 {
        GeometryWithWKTTest (@"GEOMETRYCOLLECTION()");
    }

    - (void) testGeometryWithWKT_WithEmptyGeometryCollection2 {
        GeometryWithWKTTest2(@"GEOMETRYCOLLECTION EMPTY", @"GEOMETRYCOLLECTION()");
    }

    - (void) testGeometryWithWKT_WithInvalidWKT {
        XCTAssertThrowsSpecificNamed([GFGeometry geometryWithWKT: @"INVALID WKT --"], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test encode

    - (NSString *) encodeDecode: (GFGeometry *) inputGeometry {

        NSMutableData * archive = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archive];

        [archiver encodeObject:inputGeometry];
        [archiver finishEncoding];

        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archive];
        GFGeometry * resultGeometry = [unarchiver decodeObject];

        return [resultGeometry toWKTString];
    }

    - (void) testEncode_WithPoint {
        EncodingTest(@"POINT(1 1)");
    }

    - (void) testEncode_WithMultiPoint {
        EncodingTest(@"MULTIPOINT((1 1),(2 2))");
    }

    - (void) testEncode_WithLineString {
        EncodingTest(@"LINESTRING(40 60,120 110)");
    }

    - (void) testEncode_WithMultiLineString {
        EncodingTest(@"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))");
    }

    - (void) testEncode_WithPolygon {
        EncodingTest(@"POLYGON((0 0,0 90,90 90,90 0,0 0))");
    }

    - (void) testEncode_WithMultiPolygon {
        EncodingTest(@"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testEncode_WithGeometryCollection {
        EncodingTest(@"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }

#pragma mark - Test copy

    - (void) testCopy {
        XCTAssertThrowsSpecificNamed([[[GFGeometryTestSubClass alloc] init] copy], NSException, NSInternalInconsistencyException);
    }

#pragma mark - Test toGeoJSONGeometry

    - (void) testToGeoJSONGeometry {
        XCTAssertThrowsSpecificNamed([[[GFGeometryTestSubClass alloc] init] toGeoJSONGeometry], NSException, NSInternalInconsistencyException);
    }

#pragma mark - Test mkMapOverlays

    - (void) testMKMapOverlays {
        XCTAssertThrowsSpecificNamed([[[GFGeometryTestSubClass alloc] init] mkMapOverlays], NSException, NSInternalInconsistencyException);
    }


@end