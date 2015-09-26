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

#include "internal/geofeatures/GeometryVariant.hpp"
#include "internal/geofeatures/GeometryCollection.hpp"

#include "internal/geofeatures/io/ReadWKT.hpp"

namespace gf = geofeatures;

@implementation GFGeometryCollection {
    @protected
        gf::GeometryCollection  _geometryCollection;
    }

#pragma mark - Construction

    - (instancetype)initWithArray:(NSArray *)array {
        NSParameterAssert(array != nil);

        if (self = [super init]) {

            for (GFGeometry * geometry in array) {

                if ([geometry isMemberOfClass: [GFGeometryCollection class]]) {
                    @throw [NSException exceptionWithName: NSInvalidArgumentException reason:[NSString stringWithFormat: @"Invalid class in array for initialization of %@.  GFGeometryCollections can not contain other GFGeometryCollections.", NSStringFromClass([self class])] userInfo: nil];
                }
                if (![geometry isKindOfClass: [GFGeometry class]]) {
                    @throw [NSException exceptionWithName: NSInvalidArgumentException reason:[NSString stringWithFormat: @"Invalid class in array for initialization of %@.  All array elements must be a GFGeometry or subclass of GFGeometry.", NSStringFromClass([self class])] userInfo: nil];
                }
                _geometryCollection.push_back([geometry cppGeometryVariant]);
            }
        }
        return self;
    }

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

        auto size = _geometryCollection.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, _geometryCollection.size()];
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
            return boost::apply_visitor(gf::GFInstanceFromVariant(), _geometryCollection.front());
        }
        return nil;
    }

    - (id) lastGeometry {

        if (!_geometryCollection.empty()) {
            return boost::apply_visitor(gf::GFInstanceFromVariant(), _geometryCollection.back());
        }
        return nil;
    }

    - (NSDictionary *)toGeoJSONGeometry {
        return [super toGeoJSONGeometry];
    }

#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        auto size = _geometryCollection.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, _geometryCollection.size()];
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

    - (instancetype) initWithCPPGeometryCollection: (gf::GeometryCollection) aGeometryCollection {

        if (self = [super init]) {
            _geometryCollection = aGeometryCollection;
        }
        return self;
    }

    - (const gf::GeometryCollection &) cppConstGeometryCollectionReference {
        return _geometryCollection;
    }

    - (gf::GeometryCollection &) cppGeometryCollectionReference {
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
        // TODO: Handle bad_alloc?
        _geometryCollection.push_back([aGeometry cppGeometryVariant]);
    }

    - (void) insertGeometry: (id) aGeometry atIndex: (NSUInteger) index {

        if (aGeometry == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aGeometry can not be nil."];
        }
        if (index > _geometryCollection.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, _geometryCollection.size()];
        }
        if (![aGeometry isKindOfClass: [GFGeometry class]]) {
            [NSException raise: NSInvalidArgumentException format: @"Invalid class, aGeometry must be of type GFGeometry or a subclass of GFGeometry."];
        }
        // TODO: Handle bad_alloc?
        _geometryCollection.insert(_geometryCollection.begin() + index, [aGeometry cppGeometryVariant]);
    }

    - (void) removeAllGeometries {
        _geometryCollection.clear();
    }

    - (void) removeGeometryAtIndex: (NSUInteger) index {
        if (index >= _geometryCollection.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, _geometryCollection.size()];
        }
        _geometryCollection.erase(_geometryCollection.begin() + index);
    }

@end
