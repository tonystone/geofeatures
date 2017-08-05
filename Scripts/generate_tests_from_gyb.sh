#!/bin/sh

#  process_tests_gyb.sh
#  GeoFeatures
#
#  Created by Tony Stone on 3/10/16.
#  Copyright © 2016 CocoaPods. All rights reserved.

#  Force a reload of the test data modules
rm *.pyc || true

# LineString tests
../../bin/gyb --line-directive '' -DGeometryType=LineString -DFileName=LineString.swift -o LineStringTests.swift CoordinateCollectionTests.swift.gyb

# LinearRing tests
../../bin/gyb --line-directive '' -DGeometryType=LinearRing -DFileName=LinearRing.swift -o LinearRingTests.swift CoordinateCollectionTests.swift.gyb

# MultiPoint tests
../../bin/gyb --line-directive '' -DTestInput='MultiPointTestInput' -o MultiPointTests.swift GeometryCollectionTests.swift.gyb

# MultiLineString tests
../../bin/gyb --line-directive '' -DTestInput='MultiLineStringTestInput' -o MultiLineStringTests.swift GeometryCollectionTests.swift.gyb

# MultiPolygon tests
../../bin/gyb --line-directive '' -DTestInput='MultiPolygonTestInput' -o MultiPolygonTests.swift GeometryCollectionTests.swift.gyb

# Geometry Collection
../../bin/gyb --line-directive '' -DTestInput='GeometryCollectionTestInput' -o GeometryCollectionTests.swift GeometryCollectionTests.swift.gyb
