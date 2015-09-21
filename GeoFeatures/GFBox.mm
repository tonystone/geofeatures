/*
*   GFBox.mm
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
*  MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#include "GFBox+Protected.hpp"
#include "GFPoint+Protected.hpp"

#include "internal/geofeatures/Box.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

/**
 * @class       GFBox
 *
 * @brief       Box is used to define are square for things like bounding boxes of other geometric shapes.
 *
 * @author      Tony Stone
 * @date        6/8/15
 */

@implementation GFBox {
        gf::Box _box;
    }

    - (instancetype) initWithMinCorner:(GFPoint *) minCorner maxCorner:(GFPoint *) maxCorner {
        NSParameterAssert(minCorner != nil);
        NSParameterAssert(maxCorner != nil);
        
        if (self = [super init]) {

            _box.minCorner().set<0>([minCorner x]);
            _box.minCorner().set<1>([minCorner y]);

            _box.maxCorner().set<0>([minCorner x]);
            _box.maxCorner().set<1>([minCorner y]);
        }
        return self;
    }

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        if (self = [super init]) {
        
            try {
                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], _box);
                
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
            
            if (!coordinates || ![coordinates isKindOfClass:[NSArray class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason:@"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo:nil];
            }
            
            /*
             * Coordinates of a Box are an array of two Point coordinates. The first
             * element in the array represents the minimum corner point (minx, miny).
             * The second element in the array represents the maximum corner point (maxx, maxy).
             *
             *  {
             *      "type": "Box",
             *      "coordinates": [[100.0, 0.0], [101.0, 1.0]]
             *  }
             */
            gf::Point minCorner([coordinates[0][0] doubleValue], [coordinates[0][1] doubleValue]);
            gf::Point maxCorner([coordinates[1][0] doubleValue], [coordinates[1][1] doubleValue]);
            
            _box = gf::Box(minCorner,maxCorner);
        }
        return self;
    }

    - (GFPoint *) minCorner {
        return [[GFPoint alloc] initWithCPPPoint: _box.minCorner()];
    }

    - (GFPoint *) maxCorner {
        return [[GFPoint alloc] initWithCPPPoint: _box.maxCorner()];
    }

    - (NSDictionary *) toGeoJSONGeometry {

        double minCornerX = _box.minCorner().get<0>();
        double minCornerY = _box.minCorner().get<1>();
        double maxCornerX = _box.maxCorner().get<0>();
        double maxCornerY = _box.maxCorner().get<1>();

        return @{@"type": @"Box", @"coordinates": @[@[@(minCornerX),@(minCornerY)],@[@(maxCornerX),@(maxCornerY)]]};
    }

    - (NSArray *)mkMapOverlays {
        CLLocationCoordinate2D coordinates[5];

        coordinates[0].longitude = _box.minCorner().get<0>();
        coordinates[0].latitude  = _box.minCorner().get<1>();

        coordinates[1].longitude = _box.maxCorner().get<0>();
        coordinates[1].latitude  = _box.minCorner().get<1>();

        coordinates[2].longitude = _box.maxCorner().get<0>();
        coordinates[2].latitude  = _box.maxCorner().get<1>();

        coordinates[3].longitude = _box.minCorner().get<0>();
        coordinates[3].latitude  = _box.maxCorner().get<1>();

        coordinates[4].longitude = _box.minCorner().get<0>();
        coordinates[4].latitude  = _box.minCorner().get<1>();

        return @[[MKPolygon polygonWithCoordinates:coordinates count:5]];
    }

@end

@implementation GFBox (Protected)

    - (instancetype) initWithCPPBox: (gf::Box) aBox {
        
        if (self = [super init]) {
            _box = aBox;
        }
        return self;
    }

    - (gf::Box &) cppBoxReference {
        return _box;
    }

    - (const gf::Box &) cppBoxConstReference {
        return _box;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_box);
    }

@end
