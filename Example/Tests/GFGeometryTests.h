//
// Created by Tony Stone on 4/16/15.
// Copyright (c) 2015 Tony Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFGeometryTests : XCTestCase  {
        Class expectedClass;
    
        NSString * geoJSONGeometryName;
    
        GFGeometry * geometry1a;
        GFGeometry * geometry1b;
        GFGeometry * geometry2;
    }
@end
