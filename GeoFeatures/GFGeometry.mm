/*
*   GFGeometry.mm
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
*   Created by Tony Stone on 4/14/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#import "GFGeometry+Protected.hpp"
#import <MapKit/MapKit.h>
#import "NSString+CaseInsensitiveHasPrefix.h"

#include "internal/geofeatures/Geometry.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"
#include "internal/geofeatures/operators/UnionOperation.hpp"
#include "internal/geofeatures/operators/CentroidOperation.hpp"
#include "internal/geofeatures/operators/Length.hpp"
#include "internal/geofeatures/operators/Area.hpp"
#include "internal/geofeatures/operators/BoundingBox.hpp"
#include "internal/geofeatures/operators/PerimeterOperation.hpp"
#include "internal/geofeatures/operators/WKTOperation.hpp"
#include "internal/geofeatures/operators/Within.hpp"
#include "internal/geofeatures/operators/IsValid.hpp"
#include "internal/geofeatures/operators/Intersects.hpp"
#include "internal/geofeatures/operators/Intersection.hpp"
#include "internal/geofeatures/operators/Difference.hpp"

#include <memory>

#include <boost/algorithm/string/predicate.hpp>
#include <boost/variant.hpp>
#include <boost/variant/polymorphic_get.hpp>

namespace gf = geofeatures;

//
// Private methods
//
@interface GFGeometry ()
@end

@implementation GFGeometry

    - (instancetype) init {
        NSAssert(![self isMemberOfClass: [GFGeometry class]], @"Abstract class %@ can not be instantiated.  Please use one of the subclasses instead.", NSStringFromClass([self class]));
        self = [super init];
        return self;
    }

#pragma mark - NSCoding

    - (void)encodeWithCoder:(NSCoder *)coder {
        [coder encodeObject: [self toWKTString] forKey: @"WKT"];
    }

    - (id) initWithCoder:(NSCoder *)coder {
        NSString * wkt = [coder decodeObjectForKey: @"WKT"];
        self = [self initWithWKT: wkt];
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo: nil];
    }

#pragma mark - Public Interface

    - (BOOL) isValid {
        const auto variant = [self cppGeometryPtrVariant];

        return gf::operators::isValid(variant);
    }

    - (double)area {
        try {
            const auto variant = [self cppGeometryPtrVariant];

            return gf::operators::area(variant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (double)area: (NSError * __autoreleasing *) error {
        double area = 0.0;
        
        try {
            area = [self area];
        
        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return area;
    }

    - (double)length {
        try {
            const auto variant = [self cppGeometryPtrVariant];
            
            return gf::operators::length(variant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (double)length: (NSError * __autoreleasing *) error {
        double length = 0.0;
        
        try {
            length = [self length];
        
        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return length;
    }

    - (double)perimeter {
        try {
            const auto variant = [self cppGeometryPtrVariant];
            
            return boost::apply_visitor(gf::operators::PerimeterOperation(), variant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (double)perimeter: (NSError * __autoreleasing *) error {
        double perimeter = 0.0;
        
        try {
            perimeter = [self perimeter];
        
        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return perimeter;
    }

    - (GFPoint *)centroid {
        try {
            const auto variant = [self cppGeometryPtrVariant];
            
            return [[GFPoint alloc] initWithCPPPoint: boost::apply_visitor(gf::operators::CentroidOperation(), variant)];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFPoint *)centroid: (NSError **) error {
        try {
            return [self centroid];

        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return nil;
    }

    - (GFBox *)boundingBox {
        try {
            const auto variant = [self cppGeometryPtrVariant];
            
            return [[GFBox alloc] initWithCPPBox: gf::operators::boundingBox(variant)];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFBox *)boundingBox: (NSError **) error {
        try {
            return [self boundingBox];

        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return nil;
    }

    - (BOOL)within:(GFGeometry *)other {

        try {
            const auto variant        = [self cppGeometryPtrVariant];
            const auto otherVariant   = [other cppGeometryPtrVariant];

            return gf::operators::within(variant, otherVariant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (BOOL)within:(GFGeometry *)other error: (NSError **) error {
        BOOL within = NO;
        
        try {
            within = [self within: other];

        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return within;
    }

    - (BOOL) intersects {

        try {
            const auto variant = [self cppGeometryPtrVariant];

            return gf::operators::intersects(variant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (BOOL)intersectsError: (NSError **) error {
        BOOL intersects = NO;
        
        try {
            intersects = [self intersects];

        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return intersects;
    }

    - (BOOL) intersects: (GFGeometry *) other {
        try {
            const auto variant        = [self cppGeometryPtrVariant];
            const auto otherVariant   = [other cppGeometryPtrVariant];

            return gf::operators::intersects(variant, otherVariant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (BOOL)intersects: (GFGeometry *) other error: (NSError **) error {
        BOOL intersects = NO;
        
        try {
            intersects = [self intersects: other];

        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return intersects;
    }

    - (GFGeometry *) intersection: (GFGeometry *) other  {
        try {
            const auto variant        = [self cppGeometryPtrVariant];
            const auto otherVariant   = [other cppGeometryPtrVariant];
            
            gf::GeometryVariant result(gf::operators::intersection(variant, otherVariant));
            
            return boost::apply_visitor(gf::GFInstanceFromVariant(), result);
            
        } catch (std::invalid_argument & e) {
            @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithUTF8String: e.what()]  userInfo: nil];
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFGeometry *) intersection: (GFGeometry *) other error: (NSError * __autoreleasing * _Nullable) error {
        GFGeometry * geometry = nil;
        
        try {
            geometry = [self intersection: other];
            
        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return geometry;
    }

    - (GFGeometry *)union_: (GFGeometry *)other {
        try {
            const auto variant        = [self cppGeometryPtrVariant];
            const auto otherVariant   = [other cppGeometryPtrVariant];
            
            gf::GeometryVariant result(boost::apply_visitor( gf::operators::UnionOperation(), variant, otherVariant));

            return boost::apply_visitor(gf::GFInstanceFromVariant(), result);
        } catch (boost::geometry::overlay_invalid_input_exception & e) {
            @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithUTF8String: e.what()]  userInfo: nil];
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFGeometry *) difference: (GFGeometry *)other {
        try {
            const auto variant        = [self cppGeometryPtrVariant];
            const auto otherVariant   = [other cppGeometryPtrVariant];
            
            gf::GeometryVariant result(gf::operators::difference(variant, otherVariant));

            return boost::apply_visitor(gf::GFInstanceFromVariant(), result);
            
        } catch (std::invalid_argument & e) {
            @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithUTF8String: e.what()]  userInfo: nil];
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFGeometry *) difference: (GFGeometry *) other error: (NSError **) error {
        GFGeometry * geometry = nil;
        
        try {
            geometry = [self difference: other];

        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return geometry;
    }

    - (GFGeometry *)union_: (GFGeometry *) other error: (NSError **) error {
        GFGeometry * geometry = nil;
        
        try {
            geometry = [self union_: other];

        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return geometry;
    }

    - (NSString *)description {
        return [self toWKTString];
    }

@end

@implementation GFGeometry (Protected)

    - (instancetype) initWithWKT:(NSString *)wkt {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];
    }

@end

@implementation GFGeometry (WKT)

    + (instancetype) geometryWithWKT:(NSString *) wkt {

        if ([wkt hasPrefix: @"GEOMETRYCOLLECTION" caseInsensitive: YES]) {

            return [[GFGeometryCollection alloc] initWithWKT: wkt];

        } else if ([wkt hasPrefix: @"POINT" caseInsensitive: YES]) {

            return [[GFPoint alloc] initWithWKT: wkt];

        } else if ([wkt hasPrefix: @"MULTIPOINT" caseInsensitive: YES]) {

            return [[GFMultiPoint alloc] initWithWKT: wkt];

        } else if ([wkt hasPrefix: @"LINESTRING" caseInsensitive: YES]) {

            return [[GFLineString alloc] initWithWKT: wkt];

        } else if ([wkt hasPrefix: @"MULTILINESTRING" caseInsensitive: YES]) {

            return [[GFMultiLineString alloc] initWithWKT: wkt];

        } else if ([wkt hasPrefix: @"POLYGON" caseInsensitive: YES]) {

            return [[GFPolygon alloc] initWithWKT: wkt];

        } else if ([wkt hasPrefix: @"MULTIPOLYGON" caseInsensitive: YES]) {

            return [[GFMultiPolygon alloc] initWithWKT: wkt];
        }

        //
        // Note: there is no else if for Box because box would be unreachable since
        //       currently Box is a Polygon representation.
        //
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat:  @"Invalid WKT, %@ not supported.", wkt] userInfo:nil];
    }

    + (instancetype) geometryWithWKT:(NSString *) wkt error: (NSError * __autoreleasing *) error {
        GFGeometry * geometry = nil;
        
        try {
            geometry = [self geometryWithWKT: wkt];
            
        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return geometry;
    }

    - (NSString *) toWKTString {
        gf::GeometryPtrVariant variant = [self cppGeometryPtrVariant];
        
        std::string wkt = boost::apply_visitor(gf::operators::WKTOperation(), variant);
        
        return [NSString stringWithFormat:@"%s",wkt.c_str()];
    }


@end

@implementation GFGeometry (GeoJSON)

    + (instancetype) geometryWithGeoJSONGeometry:(NSDictionary *)geoJSONGeometryDictionary {
        NSParameterAssert(geoJSONGeometryDictionary != nil);

        GFGeometry * geometry = nil;

        Class geometryClass = NSClassFromString([NSString stringWithFormat: @"GF%@", geoJSONGeometryDictionary[@"type"]]);

        if (geometryClass) {
            geometry = [(GFGeometry *)[geometryClass alloc] initWithGeoJSONGeometry: geoJSONGeometryDictionary];
        } else {
            @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat:  @"Invalid GeoJSON Geometry Object, type %@ not supported.", geoJSONGeometryDictionary[@"type"]] userInfo:nil];
        }
        return geometry;
    }

    + (instancetype) geometryWithGeoJSONGeometry:(NSDictionary *)geoJSONGeometryDictionary  error: (NSError * __autoreleasing *) error {
        GFGeometry * geometry = nil;
        
        try {
            geometry = [self geometryWithGeoJSONGeometry: geoJSONGeometryDictionary];
            
        } catch (NSException * e) {
            if (error) {
                *error = [NSError errorWithDomain: @"GeoFeaturesDomain" code: 100 userInfo: @{NSLocalizedDescriptionKey: e.reason}];
            }
        }
        return geometry;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];
    }

    - (NSDictionary *) toGeoJSONGeometry {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];
    }

@end

@implementation GFGeometry (MapKit)

    - (NSArray *) mkMapOverlays {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];
    }

@end




