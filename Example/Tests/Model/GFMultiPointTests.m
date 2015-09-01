/*
*   GFMultiPointTests.m
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

@interface GFMultiPointTests : XCTestCase
@end

static NSString * geometry1JSONString = @"{ \"type\": \"MultiPoint\","
        "    \"coordinates\": [ [100.0, 0.0], [101.0, 1.0] ]"
        "}";

static NSString * geometry2JSONString = @"{ \"type\": \"MultiPoint\","
        "    \"coordinates\": [ [100.0, 0.0], [101.0, 1.0] ]"
        "}";

static NSString * invalidGeometryJSONString = @"{ \"type\": \"%@\","
        "    \"coordinates\": {}"
        "   }";

@implementation GFMultiPointTests {
        Class expectedClass;

        NSString * geoJSONGeometryName;

        GFGeometry * geometry1a;
        GFGeometry * geometry1b;
        GFGeometry * geometry2;
    }

    - (void)setUp {
        [super setUp];

        expectedClass       = NSClassFromString( @"GFMultiPoint");
        geoJSONGeometryName = @"MultiPoint";
        
        geometry1a = [GFGeometry geometryWithGeoJSONGeometry: [NSJSONSerialization JSONObjectWithData: [geometry1JSONString dataUsingEncoding: NSUTF8StringEncoding] options: 0 error: nil]];
        geometry1b = [GFGeometry geometryWithGeoJSONGeometry: [NSJSONSerialization JSONObjectWithData: [geometry1JSONString dataUsingEncoding: NSUTF8StringEncoding] options: 0 error: nil]];
        geometry2  = [GFGeometry geometryWithGeoJSONGeometry: [NSJSONSerialization JSONObjectWithData: [geometry2JSONString dataUsingEncoding: NSUTF8StringEncoding] options: 0 error: nil]];
    }

    - (void)tearDown {

        expectedClass       = nil;
        geoJSONGeometryName = nil;
        
        geometry1a = nil;
        geometry2           = nil;

        [super tearDown];
    }

    - (void)testConstruction {

        XCTAssertNotNil(geometry1a);
        XCTAssertNotNil(geometry2);

        XCTAssertEqual([geometry1a class], expectedClass);
        XCTAssertEqual([geometry2 class], expectedClass);
    }

    - (void)testFailedConstruction {

        NSDictionary * testJSON  = [NSJSONSerialization JSONObjectWithData: [[NSString stringWithFormat:invalidGeometryJSONString, geoJSONGeometryName] dataUsingEncoding: NSUTF8StringEncoding]  options: 0 error: nil];

        XCTAssertThrowsSpecificNamed([GFGeometry geometryWithGeoJSONGeometry: testJSON], NSException, @"Invalid GeoJSON");
    }

    - (void) testToGeoJSONGeometry {

        XCTAssertEqualObjects([geometry1a toGeoJSONGeometry], [NSJSONSerialization JSONObjectWithData: [geometry1JSONString dataUsingEncoding: NSUTF8StringEncoding] options: 0 error: nil]);
    }

    - (void) testDescription {

        // Currently we only check if it returns something and its not nill

        XCTAssertNotNil([geometry1a description]);
        XCTAssertNotNil([geometry2 description]);

        XCTAssertTrue ([[geometry1a description] length] > 0);
        XCTAssertTrue ([[geometry2 description] length] > 0);
    }

    - (void) testMapOverlays {
        
        NSArray * mapOverlays = [geometry1a mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 2);
        
        for (int i = 0; i < [mapOverlays count]; i++) {
            id mapOverlay = [mapOverlays objectAtIndex: i];
            
            XCTAssertTrue   ([mapOverlay isKindOfClass: [MKCircle class]]);
            
            MKCircle * circle = mapOverlay;
            
            XCTAssertTrue   ([circle coordinate].longitude == 100.0 + i);
            XCTAssertTrue   ([circle coordinate].latitude == 0.0 + i);
        }
    }

    - (void) testObjectAtIndexedSubscript {

        GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"];

        XCTAssertNoThrow(multiPoint[0]);
        XCTAssertNoThrow(multiPoint[1]);
        XCTAssertThrowsSpecificNamed(multiPoint[2], NSException, NSRangeException);
        
        XCTAssertEqualObjects([multiPoint[0] toWKTString], @"POINT(1 1)");
        XCTAssertEqualObjects([multiPoint[1] toWKTString], @"POINT(2 2)");
    }

@end


