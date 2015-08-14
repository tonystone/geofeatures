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

@interface GFGeometryPolygonTests : GFGeometryTests
@end

static NSString * geometry1JSONString = @"{ \"type\": \"Polygon\","
        "    \"coordinates\": ["
        "      [ [100.0, 0.0], [200.0, 0.0], [200.0, 100.0], [100.0, 1.0], [100.0, 0.0] ],"
        "      [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]"
        "      ]"
        "   }";

static NSString * geometry2JSONString = @"{ \"type\": \"Polygon\","
        "    \"coordinates\": ["
        "      [ [98.0, 0.0], [101.0, 0.0], [101.0, 1.0], [98.0, 1.0], [98.0, 0.0] ]"
        "      ]"
        "   }";

@implementation GFGeometryPolygonTests

    - (void)setUp {
        [super setUp];

        expectedClass       = NSClassFromString( @"GFPolygon");
        geoJSONGeometryName = @"Polygon";
        
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

    - (void) testUnion {
        GFGeometry * result = [geometry1a union_: geometry2];
        XCTAssertNotNil(result);
    }

    - (void) testMapOverlays {
    
        NSArray * mapOverlays = [geometry1a mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);
        
        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKPolygon class]]);
        
        MKPolygon * polygon = (MKPolygon *) [mapOverlays lastObject];
        
        XCTAssertTrue   ([polygon pointCount] == 5);
        XCTAssertTrue   ([[polygon interiorPolygons] count] == 1);
        
    }

@end