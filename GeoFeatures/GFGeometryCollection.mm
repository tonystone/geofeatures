/*
*   GFGeometryCollection.mm
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
*   Created by Tony Stone on 6/5/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#include "GFGeometryCollection+Protected.hpp"
#include "GFGeometry+Protected.hpp"

#include "internal/GFPoint+Protected.hpp"
#include "internal/GFLineString+Protected.hpp"
#include "internal/GFRing+Protected.hpp"
#include "internal/GFBox+Protected.hpp"
#include "internal/GFPolygon+Protected.hpp"
#include "internal/GFMultiPoint+Protected.hpp"
#include "internal/GFMultiLineString+Protected.hpp"
#include "internal/GFMultiPolygon+Protected.hpp"

#include "internal/geofeatures/GeometryVariant.hpp"
#include "internal/geofeatures/GeometryCollection.hpp"

#include "internal/geofeatures/io/ReadWKT.hpp"

namespace gf = geofeatures;

@implementation GFGeometryCollection {
    @protected
        gf::GeometryCollection<>  _geometryCollection;
    }

#pragma mark - Construction

    - (instancetype)initWithWKT: (NSString *) wkt {

        if (self = [super init]) {
            try {
                gf::io::readWKT([wkt cStringUsingEncoding: NSUTF8StringEncoding], _geometryCollection);

            } catch (std::exception & e) {
                @throw [NSException exceptionWithName: @"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo: nil];
            }
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry: (NSDictionary *) jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        if (self = [super init]) {
            id type = jsonDictionary[@"type"];

            if (!type ||
                ![type isKindOfClass: [NSString class]] ||
                ![[type lowercaseString] isEqualToString: @"geometrycollection"]) {

                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: @"Invalid GeoJSON Geometry Object, incorrect type or type missing." userInfo: nil];
            }

            id geometries = jsonDictionary[@"geometries"];

            if (!geometries ||
                ![geometries isKindOfClass: [NSArray class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: @"Invalid GeoJSON Geometry Object, no geometries found or geometries of an invalid type." userInfo: nil];
            }
            _geometryCollection = gf::GFGeometryCollection::geometryCollectionWithGeoJSONGeometries(geometries);
        }
        return self;
    }

    - (instancetype)initWithArray:(NSArray *)array {
        NSParameterAssert(array != nil);

        if (self = [super init]) {

            for (GFGeometry * geometry in array) {

                if (![geometry isKindOfClass: [GFGeometry class]]) {
                    @throw [NSException exceptionWithName: NSInvalidArgumentException reason:[NSString stringWithFormat: @"Invalid class in array for initialization of %@.  All array elements must be a GFGeometry or subclass of GFGeometry.", NSStringFromClass([self class])] userInfo: nil];
                }
                // Note: geofeatures::<collection type> classes will throw an "Objective-C"
                // NSMallocException if they fail to allocate memory for the operation below
                // so no C++ exception block is required.
                _geometryCollection.push_back([geometry cppGeometryVariant]);
            }
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFGeometryCollection *) [[GFGeometryCollection class] allocWithZone: zone] initWithCPPGeometryCollection: _geometryCollection];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        return [(GFMutableGeometryCollection *) [[GFMutableGeometryCollection class] allocWithZone: zone] initWithCPPGeometryCollection: _geometryCollection];
    }

#pragma mark - Querying a GFGeometryCollection

    - (NSUInteger)count {
        return _geometryCollection.size();
    }

    - (id) geometryAtIndex: (NSUInteger) index {

        if (index >= _geometryCollection.size()) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _geometryCollection.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return boost::apply_visitor(gf::GFInstanceFromVariant(), _geometryCollection[index]);
    }

    - (id) firstGeometry {

        if (!_geometryCollection.empty()) {
            return boost::apply_visitor(gf::GFInstanceFromVariant(), *_geometryCollection.begin());
        }
        return nil;
    }

    - (id) lastGeometry {

        if (!_geometryCollection.empty()) {
            return boost::apply_visitor(gf::GFInstanceFromVariant(), *(_geometryCollection.end() - 1));
        }
        return nil;
    }

    - (NSDictionary *) toGeoJSONGeometry {
       return geofeatures::GFGeometryCollection::geoJSONGeometryWithGeometryCollection(_geometryCollection);
    }

#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        if (index >= _geometryCollection.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _geometryCollection.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return boost::apply_visitor(gf::GFInstanceFromVariant(), _geometryCollection[index]);
    }

@end

@implementation GFGeometryCollection (Protected)

    - (instancetype) initWithCPPGeometryCollection: (gf::GeometryCollection<>) aGeometryCollection {

        if (self = [super init]) {
            _geometryCollection = aGeometryCollection;
        }
        return self;
    }

    - (const gf::GeometryCollection<> &) cppConstGeometryCollectionReference {
        return _geometryCollection;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_geometryCollection);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_geometryCollection);
    }

@end


@implementation GFMutableGeometryCollection

    - (void) addGeometry: (id) aGeometry {

        if (aGeometry == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aGeometry can not be nil."];
        }
        if (![aGeometry isKindOfClass: [GFGeometry class]]) {
            [NSException raise: NSInvalidArgumentException format: @"Invalid class, aGeometry must be of type GFGeometry or a subclass of GFGeometry."];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _geometryCollection.push_back([aGeometry cppGeometryVariant]);
    }

    - (void) insertGeometry: (id) aGeometry atIndex: (NSUInteger) index {

        if (aGeometry == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aGeometry can not be nil."];
        }
        if (index > _geometryCollection.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _geometryCollection.size()];
        }
        if (![aGeometry isKindOfClass: [GFGeometry class]]) {
            [NSException raise: NSInvalidArgumentException format: @"Invalid class, aGeometry must be of type GFGeometry or a subclass of GFGeometry."];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _geometryCollection.insert(_geometryCollection.begin() + index, [aGeometry cppGeometryVariant]);
    }

    - (void) removeAllGeometries {
        _geometryCollection.clear();
    }

    - (void) removeGeometryAtIndex: (NSUInteger) index {
        if (index >= _geometryCollection.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _geometryCollection.size()];
        }
        _geometryCollection.erase(_geometryCollection.begin() + index);
    }

    - (void) setObject: (id) aGeometry atIndexedSubscript: (NSUInteger) index {

        if (aGeometry == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aGeometry can not be nil."];
        }
        if (index > _geometryCollection.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _geometryCollection.size()];
        }
        if (![aGeometry isKindOfClass: [GFGeometry class]]) {
            [NSException raise: NSInvalidArgumentException format: @"Invalid class, aGeometry must be of type GFGeometry or a subclass of GFGeometry."];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        if (index == _geometryCollection.size()) {
            _geometryCollection.push_back([aGeometry cppGeometryVariant]);
        } else {
            _geometryCollection[index] = [aGeometry cppGeometryVariant];
        }
    }

@end

#pragma mark - Primitives

geofeatures::GeometryCollection<> geofeatures::GFGeometryCollection::geometryCollectionWithGeoJSONGeometries(NSArray * geometries) {

    GeometryCollection<> geometryCollection;
    //
    //     {
    //         "type": "GeometryCollection",
    //         "geometries": [
    //              { "type": "Point",
    //                "coordinates": [100.0, 0.0]
    //              },
    //              { "type": "LineString",
    //                "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
    //              }
    //         ]
    //     }
    //
    for (NSDictionary * geometry in geometries) {
        id type = [geometry[@"type"] lowercaseString];

        if ([type isEqualToString: @"point"]) {

            geometryCollection.push_back(gf::GFPoint::pointWithGeoJSONCoordinates(geometry[@"coordinates"]));

        }  else if ([type isEqualToString: @"linestring"]) {

            geometryCollection.push_back(gf::GFLineString::lineStringWithGeoJSONCoordinates(geometry[@"coordinates"]));

        } else if ([type isEqualToString: @"polygon"]) {

            geometryCollection.push_back(gf::GFPolygon::polygonWithGeoJSONCoordinates(geometry[@"coordinates"]));

        } else if ([type isEqualToString: @"multipoint"]) {

            geometryCollection.push_back(gf::GFMultiPoint::multiPointWithGeoJSONCoordinates(geometry[@"coordinates"]));

        } else if ([type isEqualToString: @"multilinestring"]) {

            geometryCollection.push_back(gf::GFMultiLineString::multiLineStringWithGeoJSONCoordinates(geometry[@"coordinates"]));

        } else if ([type isEqualToString: @"multipolygon"]) {

            geometryCollection.push_back(gf::GFMultiPolygon::multiPolygonWithGeoJSONCoordinates(geometry[@"coordinates"]));

        } else if ([type isEqualToString: @"geometrycollection"]) {
            geometryCollection.push_back(gf::GFGeometryCollection::geometryCollectionWithGeoJSONGeometries(geometry[@"geometries"]));
        }
    }
    return geometryCollection;
}

NSDictionary * geofeatures::GFGeometryCollection::geoJSONGeometryWithGeometryCollection(const geofeatures::GeometryCollection<> & geometryCollection) {
    return @{@"type": @"GeometryCollection", @"geometries": geoJSONGeometriesWithGeometryCollection(geometryCollection)};
}

NSArray * geofeatures::GFGeometryCollection::geoJSONGeometriesWithGeometryCollection(const geofeatures::GeometryCollection<> & geometryCollection) {

    /**
     * static_visitor to transform the variant type into a GeoJSON Array of coordinates.
    */
    class GeoJSONGeometryFromVariant : public  boost::static_visitor<NSDictionary *> {

    public:
        NSDictionary * operator()(const gf::Point & v) const {
            return gf::GFPoint::geoJSONGeometryWithPoint(v);
        }
        NSDictionary * operator()(const gf::MultiPoint & v) const {
            return gf::GFMultiPoint::geoJSONGeometryWithMultiPoint(v);
        }
        NSDictionary * operator()(const gf::Box & v) const {
            return gf::GFBox::geoJSONGeometryWithBox(v);
        }
        NSDictionary * operator()(const gf::LineString & v) const {
            return gf::GFLineString::geoJSONGeometryWithLineString(v);
        }
        NSDictionary * operator()(const gf::Ring & v) const {
            return gf::GFRing::geoJSONGeometryWithRing(v);
        }
        NSDictionary * operator()(const gf::MultiLineString & v) const {
            return gf::GFMultiLineString::geoJSONGeometryWithMultiLineString(v);
        }
        NSDictionary * operator()(const gf::Polygon & v) const {
            return gf::GFPolygon::geoJSONGeometryWithPolygon(v);
        }
        NSDictionary * operator()(const gf::MultiPolygon & v) const {
            return gf::GFMultiPolygon::geoJSONGeometryWithMultiPolygon(v);
        }
        NSDictionary * operator()(const gf::GeometryCollection<> & v) const {
            return geofeatures::GFGeometryCollection::geoJSONGeometryWithGeometryCollection(v);
        }
    };

    NSMutableArray * geometries = [[NSMutableArray alloc] init];

    for (auto it = geometryCollection.begin();  it != geometryCollection.end(); ++it ) {
        [geometries addObject: boost::apply_visitor(GeoJSONGeometryFromVariant(), *it)];
    }
    return geometries;
}

//id <MKOverlay> geofeatures::GFGeometryCollection::mkOverlayWithGeometryCollection(const geofeatures::GeometryCollection<> & geometryCollection) {
//   return nil;
//}

