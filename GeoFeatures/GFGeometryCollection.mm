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
        gf::GeometryCollection  _geometryCollection;
    }

#pragma mark - Public methods

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

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFGeometryCollection *)[[self class] allocWithZone:zone] initWithCPPGeometryCollection: _geometryCollection];
    }

    - (NSUInteger)count {
        return _geometryCollection.size();
    }

    - (id) geometryAtIndex: (NSUInteger) index {

        auto size = _geometryCollection.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, _geometryCollection.size()];
        }
        //
        // Note: Unless the container is mutating, the access
        //       below should not throw because we've already
        //       checked for out_of_rang above.
        //
        return boost::apply_visitor(gf::GFInstanceFromVariant(), _geometryCollection.at(index));
    }

    - (id) firstGeometry {

        if (_geometryCollection.size() > 0) {
            return boost::apply_visitor(gf::GFInstanceFromVariant(), _geometryCollection.front());
        }
        return nil;
    }

    - (id) lastGeometry {

        if (_geometryCollection.size() > 0) {
            return boost::apply_visitor(gf::GFInstanceFromVariant(), _geometryCollection.back());
        }
        return nil;
    }

#pragma mark - Protected methods

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
        // Note: Unless the container is mutating, the access
        //       below should not throw because we've already
        //       checked for out_of_rang above.
        //
        return boost::apply_visitor(gf::GFInstanceFromVariant(), _geometryCollection.at(index));
    }

@end

@implementation GFGeometryCollection (Protected)

    - (instancetype) initWithCPPGeometryCollection: (gf::GeometryCollection) aGeometryCollection {

        if (self = [super init]) {
            _geometryCollection = aGeometryCollection;
        }
        return self;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_geometryCollection);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_geometryCollection);
    }

@end
