/*
*   GFPolygon.mm
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
*   Created by Tony Stone on 6/3/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#import "GFPolygon.h"
#include "GFPolygon+Protected.hpp"
#include "GFRing+Protected.hpp"
#include "GFGeometryCollection+Protected.hpp"

#include "internal/geofeatures/Polygon.hpp"
#include "internal/geofeatures/GeometryCollection.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/correct.hpp>
#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

/**
 * @class       GFPolygon
 *
 * @brief       Main implementation for GFPolygon.
 *
 * @author      Tony Stone
 * @date        6/6/15
 */
@implementation GFPolygon {
    @protected
        gf::Polygon _polygon;
    }

#pragma mark - Construction

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        if (self = [super init]) {
            try {
                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], _polygon);

            } catch (std::exception & e) {
                @throw [NSException exceptionWithName: @"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo: nil];
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
            _polygon = gf::GFPolygon::polygonWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFPolygon *) [[GFPolygon class] allocWithZone: zone] initWithCPPPolygon: _polygon];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        return [(GFMutablePolygon *) [[GFMutablePolygon class] allocWithZone: zone] initWithCPPPolygon: _polygon];
    }

#pragma mark - Querying a GFPolygon

    - (GFRing *) outerRing {
        return [[GFRing alloc] initWithCPPRing: _polygon.outer()];
    }

    - (GFGeometryCollection *) innerRings {
        gf::GeometryCollection<> geometryCollection;

        const auto& inners  = _polygon.inners();

        for (auto it = inners.begin(); it != inners.end(); ++it) {
            // Note: geofeatures::<type>s will throw an "Objective-C" NSMallocException
            // if they fail to allocate memory for the operation below so
            // no C++ exception block is required.
            geometryCollection.push_back(*it);
        }
        return [[GFGeometryCollection alloc] initWithCPPGeometryCollection: geometryCollection];
    }

    - (NSDictionary *) toGeoJSONGeometry {
        return gf::GFPolygon::geoJSONGeometryWithPolygon(_polygon);
    }

    - (NSArray *) mkMapOverlays {
        return @[gf::GFPolygon::mkOverlayWithPolygon(_polygon)];
    }

@end

@implementation GFPolygon (Protected)

    - (instancetype) initWithCPPPolygon: (gf::Polygon) aPolygon {

        if (self = [super init]) {
            _polygon = aPolygon;
        }
        return self;
    }

    - (const gf::Polygon &) cppConstPolygonReference {
        return _polygon;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_polygon);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_polygon);
    }

@end


@implementation GFMutablePolygon

    - (void) setOuterRing: (GFRing *) outerRing {

        if (outerRing == nil) {
            [NSException raise: NSInvalidArgumentException format: @"outerRing cannot be nil."];
        }
        _polygon.setOuter([outerRing cppConstRingReference]);
    }

    - (void) setInnerRings: (GFGeometryCollection *) aRingCollection {

        if (aRingCollection == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aRingCollection cannot be nil."];
        }

        const auto rings = [aRingCollection cppConstGeometryCollectionReference];
        //
        // Loop through each element in the collection
        // and apply the visitor to add it to the list.
        //
        for (auto it = rings.begin();  it != rings.end(); ++it ) {
            auto variant = *it;

            if (variant.type() == typeid(geofeatures::Ring)) {
                // Note: geofeatures::<collection type> classes will throw an "Objective-C"
                // NSMallocException if they fail to allocate memory for the operation below
                // so no C++ exception block is required.
                _polygon.inners().push_back(boost::strict_get<geofeatures::Ring>(*it));
            } else {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: @"All geometries in the innerRing collection must be of type GFRing." userInfo: nil];
            }
        }
    }

@end

#pragma mark - Primitives

gf::Polygon geofeatures::GFPolygon::polygonWithGeoJSONCoordinates(NSArray * coordinates) {

    //
    // Note: Coordinates of a Polygon are an array of
    // LinearRing coordinate arrays. The first element
    // in the array represents the exterior ring. Any
    // subsequent elements represent interior rings (or holes).
    //
    // No holes:
    //
    // { "type": "Polygon",
    //      "coordinates": [
    //          [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
    //      ]
    // }
    //
    //  With holes:
    //
    // { "type": "Polygon",
    //      "coordinates": [
    //              [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
    //              [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
    //          ]
    // }
    //
    gf::Polygon polygon;

    //
    //  Get the outer ring
    //
    for (NSArray * coordinate in coordinates[0]) {
        polygon.outer().push_back(gf::Point([coordinate[0] doubleValue], [coordinate[1] doubleValue]));
    }

    polygon.inners().resize([coordinates count] - 1);

    //
    // Now the innerRings if any
    //
    for (NSUInteger x = 1; x < [coordinates count]; x++) {
        auto& innerRing = polygon.inners()[x - 1];

        for (NSArray * coordinate in coordinates[x]) {
            innerRing.push_back(gf::Point([coordinate[0] doubleValue], [coordinate[1] doubleValue]));
        }
    }
    // Make sure this polygon is closed.
    boost::geometry::correct(polygon);

    return polygon;
}

NSDictionary * geofeatures::GFPolygon::geoJSONGeometryWithPolygon(const geofeatures::Polygon & polygon) {
    return @{@"type": @"Polygon", @"coordinates": gf::GFPolygon::geoJSONCoordinatesWithPolygon(polygon)};
}

NSArray * geofeatures::GFPolygon::geoJSONCoordinatesWithPolygon(const gf::Polygon & polygon)  {

    NSMutableArray * rings = [[NSMutableArray alloc] init];
    NSUInteger currentRing = 0;

    auto outerCoordinateCount = polygon.outer().size();

    // Created the outer ring
    NSMutableArray * outerRingArray = [[NSMutableArray alloc] init];
    for (auto i = 0; i < outerCoordinateCount; i++) {
        const auto& point = polygon.outer()[i];

        double longitude = point.get<0>();
        double latitude  = point.get<1>();

        outerRingArray[i] = @[@(longitude),@(latitude)];
    }
    rings[currentRing] = outerRingArray;

    // Now the inner rings
    for (auto x = 0; x < polygon.inners().size(); x++) {
        const auto& innerRing = polygon.inners()[x];

        NSMutableArray * innerRingArray = [[NSMutableArray alloc] init];

        size_t innerPointCount = innerRing.size();

        // Created the outer ring
        for (auto i = 0; i < innerPointCount; i++) {
            const auto& point = innerRing[i];

            double longitude = point.get<0>();
            double latitude  = point.get<1>();

            innerRingArray[i] = @[@(longitude),@(latitude)];
        }
        rings[++currentRing] = innerRingArray;
    }

    return rings;
}

id <MKOverlay> geofeatures::GFPolygon::mkOverlayWithPolygon(const gf::Polygon & polygon) {

    MKPolygon * mkPolygon = nil;

    //
    //  Get the outer ring
    //
    auto outerCoordinateCount = polygon.outer().size();
    CLLocationCoordinate2D * outerCoordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * outerCoordinateCount);

    for (auto i = 0; i < outerCoordinateCount; i++) {
        const auto& point = polygon.outer()[i];

        outerCoordinates[i].longitude = point.get<0>();
        outerCoordinates[i].latitude  = point.get<1>();
    }

    NSMutableArray * innerPolygons = [[NSMutableArray alloc] initWithCapacity: polygon.inners().size()];

    //
    // Now the innerRings if any
    //
    for (auto x = 0; x < polygon.inners().size(); x++) {

        const auto& innerRing = polygon.inners()[x];

        size_t innerCoordinateCount = innerRing.size();
        CLLocationCoordinate2D * innerCoordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * innerCoordinateCount);

        for (size_t i = 0; i < innerCoordinateCount; i++) {
            const auto& point = innerRing[i];

            innerCoordinates[i].longitude = point.get<0>();
            innerCoordinates[i].latitude  = point.get<1>();
        }
        MKPolygon * innerPolygon = [MKPolygon polygonWithCoordinates: innerCoordinates count: innerCoordinateCount];

        [innerPolygons addObject: innerPolygon];

        free(innerCoordinates);
    }
    mkPolygon = [MKPolygon polygonWithCoordinates: outerCoordinates count: outerCoordinateCount interiorPolygons: innerPolygons];

    free(outerCoordinates);

    return mkPolygon;
}


