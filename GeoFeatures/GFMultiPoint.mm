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
#include "GFPoint+Primitives.hpp"

#include "internal/geofeatures/MultiPoint.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

@implementation GFMultiPoint {
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
            //
            // Note: Coordinates of a MultiPoint are an array of positions
            //
            // { "type": "MultiPoint",
            //      "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
            // }
            //
            for (NSArray * coordinate in coordinates) {
                _multiPoint.push_back(gf::GFPoint::pointWithGeoJSONCoordinates(coordinate));
            }
        }
        return self;
    }

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFMultiPoint *) [[self class] allocWithZone: zone] initWithCPPMultiPoint: _multiPoint];
    }

#pragma mark - Querying a GFMultiPoint

    - (NSUInteger)count {
        return _multiPoint.size();
    }

    - (GFPoint *) geometryAtIndex: (NSUInteger) index {

        auto size = _multiPoint.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, _multiPoint.size()];
        }
        //
        // Note: Unless the container is mutating, the access
        //       below should not throw because we've already
        //       checked for out_of_rang above.
        //
        return [[GFPoint alloc] initWithCPPPoint: _multiPoint.at(index)];
    }

    - (GFPoint *) firstGeometry {

        if (_multiPoint.size() == 0) {
            return nil;
        }
        return [[GFPoint alloc] initWithCPPPoint: _multiPoint.front()];
    }

    - (GFPoint *) lastGeometry {

        if (_multiPoint.size() == 0) {
            return nil;
        }
        return [[GFPoint alloc] initWithCPPPoint: _multiPoint.back()];
    }

#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        auto size = _multiPoint.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, _multiPoint.size()];
        }
        //
        // Note: Unless the container is mutating, the access
        //       below should not throw because we've already
        //       checked for out_of_rang above.
        //
        return [[GFPoint alloc] initWithCPPPoint: _multiPoint.at(index)];
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
        NSMutableArray * points = [[NSMutableArray alloc] init];

        for (auto it = _multiPoint.begin();  it != _multiPoint.end(); ++it ) {
            [points addObject: gf::GFPoint::geoJSONCoordinatesWithPoint(*it)];
        }
        return @{@"type": @"MultiPoint", @"coordinates": points};
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
