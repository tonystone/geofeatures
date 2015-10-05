/*
*   GFMultiPolygon.mm
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
#include "GFMultiPolygon+Protected.hpp"
#include "GFPolygon+Protected.hpp"

#include "internal/geofeatures/MultiPolygon.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <vector>

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

@implementation GFMultiPolygon {
    @protected
        gf::MultiPolygon _multiPolygon;
    }

#pragma mark - Construction

    - (instancetype) initWithWKT: (NSString *) wkt {
        NSParameterAssert(wkt != nil);

        if (self = [super init]) {
            try {
                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], _multiPolygon);

            } catch (std::exception & e) {
                @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
            }
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        if (self = [super init]) {

            id coordinates = jsonDictionary[@"coordinates"];

            if (!coordinates || ![coordinates isKindOfClass: [NSArray class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: @"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo: nil];
            }
            _multiPolygon = gf::GFMultiPolygon::multiPolygonWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFMultiPolygon *) [[GFMultiPolygon class] allocWithZone: zone] initWithCPPMultiPolygon: _multiPolygon];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        return [(GFMutableMultiPolygon *) [[GFMutableMultiPolygon class] allocWithZone: zone] initWithCPPMultiPolygon: _multiPolygon];
    }

#pragma mark - Querying a GFMultiPolygon

    - (NSUInteger)count {
        return _multiPolygon.size();
    }

    - (GFPolygon *) geometryAtIndex: (NSUInteger) index {

        if (index >= _multiPolygon.size()) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) (unsigned long) (unsigned long) _multiPolygon.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFPolygon alloc] initWithCPPPolygon: _multiPolygon[index]];
    }

    - (GFPolygon *) firstGeometry {

        if (_multiPolygon.empty()) {
            return nil;
        }
        return [[GFPolygon alloc] initWithCPPPolygon: *_multiPolygon.begin()];
    }

    - (GFPolygon *) lastGeometry {

        if (_multiPolygon.empty()) {
            return nil;
        }
        return [[GFPolygon alloc] initWithCPPPolygon: *(_multiPolygon.end() - 1)];
    }

#pragma mark - Indexed Subscripting

    - (GFPolygon *) objectAtIndexedSubscript: (NSUInteger) index {

        if (index >= _multiPolygon.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPolygon.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFPolygon alloc] initWithCPPPolygon: _multiPolygon[index]];
    }

@end

@implementation GFMultiPolygon (Protected)

    - (instancetype) initWithCPPMultiPolygon: (gf::MultiPolygon) aMultiPolygon {

        if (self = [super init]) {
            _multiPolygon = aMultiPolygon;
        }
        return self;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_multiPolygon);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_multiPolygon);
    }

#pragma mark - GeoJSON Output

    - (NSDictionary *) toGeoJSONGeometry {
        return gf::GFMultiPolygon::geoJSONGeometryWithMultiPolygon(_multiPolygon);
    }

#pragma mark - MapKit

    - (NSArray *) mkMapOverlays {
        NSMutableArray * mkPolygons = [[NSMutableArray alloc] init];

        for (auto it = _multiPolygon.begin();  it != _multiPolygon.end(); ++it ) {
            [mkPolygons addObject: gf::GFPolygon::mkOverlayWithPolygon(*it)];
        }
        return mkPolygons;
    }

@end

@implementation GFMutableMultiPolygon

    - (void) addGeometry: (GFPolygon *) aPolygon {
        if (aPolygon == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPolygon can not be nil."];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _multiPolygon.push_back([aPolygon cppConstPolygonReference]);
    }

    - (void) insertGeometry: (GFPolygon *) aPolygon atIndex: (NSUInteger) index {
        if (aPolygon == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPolygon can not be nil."];
        }
        if (index > _multiPolygon.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPolygon.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _multiPolygon.insert(_multiPolygon.begin() + index, [aPolygon cppConstPolygonReference]);
    }

    - (void) removeAllGeometries {
        _multiPolygon.clear();
    }

    - (void) removeGeometryAtIndex: (NSUInteger) index {
        if (index >= _multiPolygon.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPolygon.size()];
        }
        _multiPolygon.erase(_multiPolygon.begin() + index);
    }

    - (void) setObject: (GFPolygon *) aPolygon atIndexedSubscript: (NSUInteger) index {

        if (aPolygon == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPolygon can not be nil."];
        }
        if (index > _multiPolygon.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiPolygon.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        if (index == _multiPolygon.size()) {
            _multiPolygon.push_back([aPolygon cppConstPolygonReference]);
        } else {
            _multiPolygon[index] = [aPolygon cppConstPolygonReference];
        }
    }

@end

#pragma mark - Primitives

gf::MultiPolygon geofeatures::GFMultiPolygon::multiPolygonWithGeoJSONCoordinates(NSArray * coordinates) {

    gf::MultiPolygon multiPolygon;

    for (NSArray * polygon in coordinates) {
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        multiPolygon.push_back(gf::GFPolygon::polygonWithGeoJSONCoordinates(polygon));
    }
    return multiPolygon;
}

NSDictionary * geofeatures::GFMultiPolygon::geoJSONGeometryWithMultiPolygon(const geofeatures::MultiPolygon & multiPolygon) {
    return @{@"type": @"MultiPolygon", @"coordinates": gf::GFMultiPolygon::geoJSONCoordinatesWithMultiPolygon(multiPolygon)};
}

NSArray * geofeatures::GFMultiPolygon::geoJSONCoordinatesWithMultiPolygon(const geofeatures::MultiPolygon & multiPolygon) {
    NSMutableArray * polygons = [[NSMutableArray alloc] init];

    for (auto it = multiPolygon.begin();  it != multiPolygon.end(); ++it ) {
        [polygons addObject: gf::GFPolygon::geoJSONCoordinatesWithPolygon(*it)];
    }
    return polygons;
}
