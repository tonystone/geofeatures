/**
*   GFLineString+Protected.hpp
*
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
*   Created by Tony Stone on 9/3/15.
*/

#import "GFPolygon+Primitives.hpp"
#import <MapKit/MapKit.h>

#include "internal/geofeatures/Polygon.hpp"

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/correct.hpp>

namespace gf = geofeatures;

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
    try {
        gf::Polygon polygon = {};

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

    } catch (std::exception & e) {
        @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
    }
}

NSArray * geofeatures::GFPolygon::geoJSONCoordinatesWithPolygon(const gf::Polygon & polygon)  {

    NSMutableArray * rings = [[NSMutableArray alloc] init];

    try {
        NSUInteger currentRing = 0;

        std::vector<gf::Point>::size_type outerCoordinateCount = polygon.outer().size();

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
    } catch (std::exception & e) {
        @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
    }
    return rings;
}

id <MKOverlay> geofeatures::GFPolygon::mkOverlayWithPolygon(const gf::Polygon & polygon) {

    MKPolygon * mkPolygon = nil;

    try {
        //
        //  Get the outer ring
        //
        size_t outerCoordinateCount = polygon.outer().size();
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

    } catch (std::exception & e) {
        @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
    }
    return mkPolygon;
}