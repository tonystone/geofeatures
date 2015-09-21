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
#include "GFPolygon+Primitives.hpp"

#include "internal/geofeatures/MultiPolygon.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <vector>

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

@implementation GFMultiPolygon {
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
            //
            // Note: Coordinates of a MultiPolygon are an
            // array of Polygon coordinate arrays:
            //
            //
            //  { "type": "MultiPolygon",
            //       "coordinates": [
            //            [
            //              [[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]
            //            ],
            //            [
            //              [[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
            //              [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]
            //            ]
            //         ]
            //  }
            //
            for (NSArray * polygon in coordinates) {
                _multiPolygon.push_back(gf::GFPolygon::polygonWithGeoJSONCoordinates(polygon));
            }
        }
        return self;
    }

#pragma mark - Querying a GFMultiPolygon

    - (NSUInteger)count {
        return _multiPolygon.size();
    }

    - (GFPolygon *) geometryAtIndex: (NSUInteger) index {

        auto size = _multiPolygon.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, _multiPolygon.size()];
        }
        //
        // Note: Unless the container is mutating, the access
        //       below should not throw because we've already
        //       checked for out_of_rang above.
        //
        return [[GFPolygon alloc] initWithCPPPolygon: _multiPolygon.at(index)];
    }

    - (GFPolygon *) firstGeometry {

        if (_multiPolygon.size() == 0) {
            return nil;
        }
        return [[GFPolygon alloc] initWithCPPPolygon: _multiPolygon.front()];
    }

    - (GFPolygon *) lastGeometry {

        if (_multiPolygon.size() == 0) {
            return nil;
        }
        return [[GFPolygon alloc] initWithCPPPolygon: _multiPolygon.back()];
    }

#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        auto size = _multiPolygon.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, _multiPolygon.size()];
        }
        //
        // Note: Unless the container is mutating, the access
        //       below should not throw because we've already
        //       checked for out_of_rang above.
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

    - (gf::MultiPolygon &) cppMultiPolygonReference {
        return _multiPolygon;
    }

    - (const gf::MultiPolygon &) cppMultiPolygonConstReference {
        return _multiPolygon;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_multiPolygon);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_multiPolygon);
    }

#pragma mark - GeoJSON Output

    - (NSDictionary *) toGeoJSONGeometry {
        NSMutableArray * polygons = [[NSMutableArray alloc] init];

        for (auto it = _multiPolygon.begin();  it != _multiPolygon.end(); ++it ) {
            [polygons addObject: gf::GFPolygon::geoJSONCoordinatesWithPolygon(*it)];
        }
        return @{@"type": @"MultiPolygon", @"coordinates": polygons};
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
