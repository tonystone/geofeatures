/*
*   GFPoint.mm
*
*   Copyright 2015 The Climate Corporation
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
*   Created by Tony Stone on 6/4/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#include "GFPoint+Protected.hpp"

#include "internal/geofeatures/Point.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

/**
 * @class       GFPoint
 *
 * @brief       A 2 dimensional point.
 *
 *
 * @author      Tony Stone
 * @date        6/8/15
 */
@implementation GFPoint {
    @protected
        gf::Point _point;
    }

#pragma mark - Construction

    - (instancetype) initWithX:(double)x y:(double)y {

        if (self = [super init]) {
            _point.set<0>(x);
            _point.set<1>(y);
        }
        return self;
    }

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        if (self = [super init]) {
            try {
                
                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], _point);

            } catch (std::exception & e) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
            }
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        if (self = [super init]) {
            id coordinates = jsonDictionary[@"coordinates"];
            
            if (!coordinates || ![coordinates isKindOfClass: [NSArray  class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: @"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type."  userInfo: nil];
            }
            _point = gf::GFPoint::pointWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFPoint *) [[GFPoint class] allocWithZone: zone] initWithCPPPoint: _point];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
       return [(GFMutablePoint *) [[GFMutablePoint class] allocWithZone: zone] initWithCPPPoint: _point];
    }

#pragma mark - Read Accessors

    - (double) x {
        return _point.get<0>();
    }

    - (double) y {
        return _point.get<1>();
    }

    - (NSDictionary *) toGeoJSONGeometry {
        return gf::GFPoint::geoJSONGeometryWithPoint(_point);
    }

    - (NSArray *) mkMapOverlays {
        return @[gf::GFPoint::mkOverlayWithPoint(_point)];
    }

@end

@implementation GFPoint (Protected)

    - (instancetype) initWithCPPPoint: (gf::Point) aPoint {
        
        if (self = [super init]) {
            _point = aPoint;
        }
        return self;
    }

    - (const gf::Point &) cppConstPointReference {
        return _point;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_point);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_point);
    }

@end


@implementation GFMutablePoint

    - (void) setX: (double) x {
        _point.set<0>(x);
    }

    - (void) setY: (double) y {
        _point.set<1>(y);
    }

@end

#pragma mark - Primitives

gf::Point geofeatures::GFPoint::pointWithGeoJSONCoordinates(NSArray * coordinates) {
    //
    // { "type": "Point",
    //      "coordinates": [100.0, 0.0]
    // }
    //
    return gf::Point([coordinates[0] doubleValue], [coordinates[1] doubleValue]);
}

NSDictionary * geofeatures::GFPoint::geoJSONGeometryWithPoint(const geofeatures::Point & point) {
    return @{@"type": @"Point", @"coordinates": geoJSONCoordinatesWithPoint(point)};
}

NSArray * geofeatures::GFPoint::geoJSONCoordinatesWithPoint(const gf::Point & point) {
    double longitude = point.get<0>();
    double latitude  = point.get<1>();

    return @[@(longitude),@(latitude)];
}

id <MKOverlay> geofeatures::GFPoint::mkOverlayWithPoint(const gf::Point & point) {
    MKCircle * mkCircle = nil;

    CLLocationCoordinate2D centerPoint;

    centerPoint.longitude = point.get<0>();
    centerPoint.latitude  = point.get<1>();

    mkCircle = [MKCircle circleWithCenterCoordinate: centerPoint radius: 5.0];

    return mkCircle;
}

