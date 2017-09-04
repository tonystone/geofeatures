#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "../GeoFeatures.h"
#import "../GFBox.h"
#import "../GFGeometry.h"
#import "../GFGeometryCollection.h"
#import "../GFLineString.h"
#import "../GFLineStringAbstract.h"
#import "../GFMultiLineString.h"
#import "../GFMultiPoint.h"
#import "../GFMultiPolygon.h"
#import "../GFPoint.h"
#import "../GFPointAbstract.h"
#import "../GFPolygon.h"
#import "../GFPolygonAbstract.h"
#import "../GFRing.h"

FOUNDATION_EXPORT double GeoFeaturesVersionNumber;
FOUNDATION_EXPORT const unsigned char GeoFeaturesVersionString[];

