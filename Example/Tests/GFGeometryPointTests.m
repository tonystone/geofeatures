//
//  GeoFeaturesTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 04/14/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import "GFGeometryTests.h"
#import <MapKit/MapKit.h>

@interface GFGeometryPointTests : GFGeometryTests
@end

static NSString * geometry1JSONString = @"{ \"type\": \"Point\", "
        "    \"coordinates\": [100.0, 0.0] "
        "}";

static NSString * geometry2JSONString = @"{ \"type\": \"Point\", "
        "    \"coordinates\": [103.0, 2.0] "
        "}";

@implementation GFGeometryPointTests

    - (void)setUp {
        [super setUp];

        expectedClass       = NSClassFromString( @"GFPoint");
        geoJSONGeometryName = @"Point";
        
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

    - (void) testMapOverlays {
    
        NSArray * mapOverlays = [geometry1a mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);
        
        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKCircle class]]);
        
        MKCircle * circle = (MKCircle *) [mapOverlays lastObject];
        
        XCTAssertTrue   ([circle coordinate].longitude == 100.0);
        XCTAssertTrue   ([circle coordinate].latitude == 0.0);
    }

@end

