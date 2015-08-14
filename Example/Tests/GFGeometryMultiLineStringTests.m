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

@interface GFGeometryMultiLineStringTests : GFGeometryTests
@end

static NSString * geometry1JSONString = @"{ \"type\": \"MultiLineString\","
        "    \"coordinates\": ["
        "        [ [100.0, 0.0], [101.0, 1.0] ],"
        "        [ [102.0, 2.0], [103.0, 3.0] ]"
        "      ]"
        "}";

static NSString * geometry2JSONString = @"{ \"type\": \"MultiLineString\","
        "    \"coordinates\": ["
        "        [ [101.0, 0.0], [102.0, 1.0] ],"
        "        [ [102.0, 2.0], [103.0, 3.0] ]"
        "      ]"
        "}";

@implementation GFGeometryMultiLineStringTests

    - (void)setUp {
        [super setUp];

        expectedClass       = NSClassFromString( @"GFMultiLineString");
        geoJSONGeometryName = @"MultiLineString";
        
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
        XCTAssertTrue   ([mapOverlays count] == 2);
        
        for (int i = 0; i < [mapOverlays count]; i++) {
            id mapOverlay = [mapOverlays objectAtIndex: i];
            
            XCTAssertTrue   ([mapOverlay isKindOfClass: [MKPolyline class]]);
            
            MKPolyline * polyline = mapOverlay;
            
            XCTAssertTrue   ([polyline pointCount] == 2);
        }
    }


@end