/*
*   GFPolygonAbstract.mm
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
*   Created by Tony Stone on 6/6/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#import <MapKit/MapKit.h>

#include "GFPolygonAbstract+Protected.hpp"

#include "geofeatures/internal/Point.hpp"

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/correct.hpp>

@implementation GFPolygonAbstract
@end

namespace gf = geofeatures::internal;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation GFPolygonAbstract (Protected)

    - (instancetype) init {
        NSAssert(![self isMemberOfClass: [GFPolygonAbstract class]], @"Abstract class %@ can not be instantiated.  Please use one of the subclasses instead.", NSStringFromClass([self class]));
        return nil;
    }

#pragma clang diagnostic pop

    - (gf::Polygon) cppPolygonWithGeoJSONCoordinates:(NSArray *)coordinates {

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
                auto& innerRing = polygon.inners().at(x - 1);

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

    - (NSArray *) geoJSONCoordinatesWithCPPPolygon: (const gf::Polygon &) polygon  {

        NSMutableArray * rings = [[NSMutableArray alloc] init];

        try {
            NSUInteger currentRing = 0;

            std::vector<gf::Point>::size_type outerCoordinateCount = polygon.outer().size();

            // Created the outer ring
            NSMutableArray * outerRingArray = [[NSMutableArray alloc] init];
            for (auto i = 0; i < outerCoordinateCount; i++) {
                const auto& point = polygon.outer().at(i);

                double longitude = point.get<0>();
                double latitude  = point.get<1>();

                outerRingArray[i] = @[@(longitude),@(latitude)];
            }
            rings[currentRing] = outerRingArray;

            // Now the inner rings
            for (auto x = 0; x < polygon.inners().size(); x++) {
                const auto& innerRing = polygon.inners().at(x);

                NSMutableArray * innerRingArray = [[NSMutableArray alloc] init];

                size_t innerPointCount = innerRing.size();

                // Created the outer ring
                for (auto i = 0; i < innerPointCount; i++) {
                    const auto& point = innerRing.at(i);

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

    - (id <MKOverlay>) mkOverlayWithCPPPolygon: (const gf::Polygon &) polygon {

        MKPolygon * mkPolygon = nil;

        try {
            //
            //  Get the outer ring
            //
            size_t outerCoordinateCount = polygon.outer().size();
            CLLocationCoordinate2D * outerCoordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * outerCoordinateCount);

            for (auto i = 0; i < outerCoordinateCount; i++) {
                const auto& point = polygon.outer().at(i);

                outerCoordinates[i].longitude = point.get<0>();
                outerCoordinates[i].latitude  = point.get<1>();
            }

            NSMutableArray * innerPolygons = [[NSMutableArray alloc] initWithCapacity: polygon.inners().size()];

            //
            // Now the innerRings if any
            //
            for (auto x = 0; x < polygon.inners().size(); x++) {

                const auto& innerRing = polygon.inners().at(x);

                size_t innerCoordinateCount = innerRing.size();
                CLLocationCoordinate2D * innerCoordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * innerCoordinateCount);

                for (size_t i = 0; i < innerCoordinateCount; i++) {
                    const auto& point = innerRing.at(i);

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

@end