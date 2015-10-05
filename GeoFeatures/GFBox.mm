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
    @protected
        gf::Box _box;
    }

#pragma mark - Construction

    - (instancetype) initWithMinCorner:(GFPoint *) minCorner maxCorner:(GFPoint *) maxCorner {
        NSParameterAssert(minCorner != nil);
        NSParameterAssert(maxCorner != nil);
        
        if (self = [super init]) {

            _box.minCorner().set<0>([minCorner x]);
            _box.minCorner().set<1>([minCorner y]);

            _box.maxCorner().set<0>([maxCorner x]);
            _box.maxCorner().set<1>([maxCorner y]);
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
            _box = gf::GFBox::boxWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFBox *)[[GFBox class] allocWithZone:zone] initWithCPPBox: _box];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        return [(GFMutableBox *) [[GFMutableBox class] allocWithZone:zone] initWithCPPBox: _box];
    }

#pragma mark - Read Accessors

    - (GFPoint *) minCorner {
        return [[GFPoint alloc] initWithCPPPoint: _box.minCorner()];
    }

    - (GFPoint *) maxCorner {
        return [[GFPoint alloc] initWithCPPPoint: _box.maxCorner()];
    }

    - (NSDictionary *) toGeoJSONGeometry {
        return gf::GFBox::geoJSONGeometryWithBox(_box);
    }

    - (NSArray *)mkMapOverlays {
        return @[gf::GFBox::mkOverlayWithBox(_box)];
    }

@end

@implementation GFBox (Protected)

    - (instancetype) initWithCPPBox: (gf::Box) aBox {
        
        if (self = [super init]) {
            _box = aBox;
        }
        return self;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_box);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_box);
    }

@end

@implementation GFMutableBox : GFBox

    - (void) setMinCorner: (GFPoint *) minCorner {
        _box.minCorner().set<0>([minCorner x]);
        _box.minCorner().set<1>([minCorner y]);
    }

    - (void) setMaxCorner: (GFPoint *) maxCorner {
        _box.maxCorner().set<0>([maxCorner x]);
        _box.maxCorner().set<1>([maxCorner y]);
    }

@end

#pragma mark - Primitives

gf::Box geofeatures::GFBox::boxWithGeoJSONCoordinates(NSArray * coordinates) {

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

    return gf::Box(minCorner,maxCorner);
}

NSDictionary * geofeatures::GFBox::geoJSONGeometryWithBox(const geofeatures::Box & box) {
    return @{@"type": @"Box", @"coordinates": geoJSONCoordinatesWithBox(box)};
}

NSArray * geofeatures::GFBox::geoJSONCoordinatesWithBox(const gf::Box & box) {

    double minCornerX = box.minCorner().get<0>();
    double minCornerY = box.minCorner().get<1>();
    double maxCornerX = box.maxCorner().get<0>();
    double maxCornerY = box.maxCorner().get<1>();

    return @[@[@(minCornerX),@(minCornerY)],@[@(maxCornerX),@(maxCornerY)]];
}

id <MKOverlay> geofeatures::GFBox::mkOverlayWithBox(const gf::Box & box) {
    CLLocationCoordinate2D coordinates[5];

    coordinates[0].longitude = box.minCorner().get<0>();
    coordinates[0].latitude  = box.minCorner().get<1>();

    coordinates[1].longitude = box.maxCorner().get<0>();
    coordinates[1].latitude  = box.minCorner().get<1>();

    coordinates[2].longitude = box.maxCorner().get<0>();
    coordinates[2].latitude  = box.maxCorner().get<1>();

    coordinates[3].longitude = box.minCorner().get<0>();
    coordinates[3].latitude  = box.maxCorner().get<1>();

    coordinates[4].longitude = box.minCorner().get<0>();
    coordinates[4].latitude  = box.minCorner().get<1>();

    return [MKPolygon polygonWithCoordinates:coordinates count:5];
}
