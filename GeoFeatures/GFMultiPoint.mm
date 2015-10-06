/*
*   GFMultiPoint.mm
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
#include "GFMultiPoint+Protected.hpp"
#include "GFPoint+Protected.hpp"

#include "internal/geofeatures/MultiPoint.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

@implementation GFMultiPoint {
    @protected
        gf::MultiPoint _multiPoint;
    }

#pragma mark - Construction

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);
        
        if (self = [super init]) {
            try {
                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], _multiPoint);

            } catch (std::exception & e) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithUTF8String: e.what()] userInfo: nil];
            }
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        if (self = [super init]) {

            id coordinates = jsonDictionary[@"coordinates"];

            if (!coordinates || ![coordinates isKindOfClass:[NSArray class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason:@"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo:nil];
            }
            _multiPoint = gf::GFMultiPoint::multiPointWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFMultiPoint *) [[GFMultiPoint class] allocWithZone: zone] initWithCPPMultiPoint: _multiPoint];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        return [(GFMutableMultiPoint *) [[GFMutableMultiPoint class] allocWithZone: zone] initWithCPPMultiPoint: _multiPoint];
    }

#pragma mark - Querying a GFMultiPoint

    - (NSUInteger)count {
        return _multiPoint.size();
    }

    - (GFPoint *) geometryAtIndex: (NSUInteger) index {

        if (index >= _multiPoint.size()) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPoint.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFPoint alloc] initWithCPPPoint: _multiPoint[index]];
    }

    - (GFPoint *) firstGeometry {

        if (_multiPoint.empty()) {
            return nil;
        }
        return [[GFPoint alloc] initWithCPPPoint: *_multiPoint.begin()];
    }

    - (GFPoint *) lastGeometry {

        if (_multiPoint.empty()) {
            return nil;
        }
        return [[GFPoint alloc] initWithCPPPoint: *(_multiPoint.end() - 1)];
    }

#pragma mark - Indexed Subscripting

    - (GFPoint *) objectAtIndexedSubscript: (NSUInteger) index {

        if (index >= _multiPoint.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPoint.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFPoint alloc] initWithCPPPoint: _multiPoint[index]];
    }

@end

@implementation GFMultiPoint (Protected)

    - (instancetype) initWithCPPMultiPoint: (gf::MultiPoint) aMultiPoint {

        if (self = [super init]) {
            _multiPoint = aMultiPoint;
        }
        return self;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_multiPoint);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_multiPoint);
    }

#pragma mark - GeoJSON Output

    - (NSDictionary *)toGeoJSONGeometry {
        return gf::GFMultiPoint::geoJSONGeometryWithMultiPoint(_multiPoint);
    }

#pragma mark - MapKit

    - (NSArray *)mkMapOverlays {
        NSMutableArray * mkPolygons = [[NSMutableArray alloc] init];

        for (auto it = _multiPoint.begin();  it != _multiPoint.end(); ++it ) {
            [mkPolygons addObject: gf::GFPoint::mkOverlayWithPoint(*it)];
        }
        return mkPolygons;
    }

@end

@implementation GFMutableMultiPoint

    - (void) addGeometry: (GFPoint *) aPoint {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _multiPoint.push_back(gf::Point([aPoint x], [aPoint y]));
    }

    - (void) insertGeometry: (GFPoint *) aPoint atIndex: (NSUInteger) index {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        if (index > _multiPoint.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPoint.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _multiPoint.insert(_multiPoint.begin() + index, gf::Point([aPoint x], [aPoint y]));
    }

    - (void) removeAllGeometries {
        _multiPoint.clear();
    }

    - (void) removeGeometryAtIndex: (NSUInteger) index {

        if (index >= _multiPoint.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPoint.size()];
        }
        _multiPoint.erase(_multiPoint.begin() + index);
    }

    - (void) setObject: (GFPoint *) aPoint atIndexedSubscript: (NSUInteger) index {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        if (index > _multiPoint.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPoint.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        if (index == _multiPoint.size()) {
            _multiPoint.push_back([aPoint cppConstPointReference]);
        } else {
            _multiPoint[index] = [aPoint cppConstPointReference];
        }
    }

@end

#pragma mark - Primitives

gf::MultiPoint geofeatures::GFMultiPoint::multiPointWithGeoJSONCoordinates(NSArray * coordinates) {
    gf::MultiPoint multiPoint;

    for (NSArray * coordinate in coordinates) {
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        multiPoint.push_back(gf::GFPoint::pointWithGeoJSONCoordinates(coordinate));
    }
    return multiPoint;
}

NSDictionary * geofeatures::GFMultiPoint::geoJSONGeometryWithMultiPoint(const geofeatures::MultiPoint & multiPoint) {
    return @{@"type": @"MultiPoint", @"coordinates": gf::GFMultiPoint::geoJSONCoordinatesWithMultiPoint(multiPoint)};
}

NSArray * geofeatures::GFMultiPoint::geoJSONCoordinatesWithMultiPoint(const geofeatures::MultiPoint & multiPoint) {

    NSMutableArray * points = [[NSMutableArray alloc] init];

    for (auto it = multiPoint.begin();  it != multiPoint.end(); ++it ) {
        [points addObject: gf::GFPoint::geoJSONCoordinatesWithPoint(*it)];
    }
    return points;
}
