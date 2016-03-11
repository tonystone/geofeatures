#!/bin/sh

#  process_tests_gyb.sh
#  GeoFeatures2
#
#  Created by Tony Stone on 3/10/16.
#  Copyright © 2016 CocoaPods. All rights reserved.

cd Tests

# LineString FloatingPrecision

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2D -D"TestTuple0=(x: 1.0, y: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0)" -D"Precision=FloatingPrecision()" -DGeometryType=LineString -o LineStringCoordinate2DFloatingPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2DM -D"TestTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"Precision=FloatingPrecision()" -DGeometryType=LineString -o LineStringCoordinate2DMFloatingPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3D -D"TestTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"Precision=FloatingPrecision()" -DGeometryType=LineString -o LineStringCoordinate3DFloatingPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3DM -D"TestTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"Precision=FloatingPrecision()" -DGeometryType=LineString -o LineStringCoordinate3DMFloatingPrecisionTests.swift CoordinateCollectionTests.swift.gyb

#LineString FixedPrecision

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2D -D"TestTuple0=(x: 1.001, y: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -DGeometryType=LineString -o LineStringCoordinate2DFixedPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2DM -D"TestTuple0=(x: 1.001, y: 1.001, m: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, m: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -DGeometryType=LineString -o LineStringCoordinate2DMFixedPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3D -D"TestTuple0=(x: 1.001, y: 1.001, z: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, z: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -DGeometryType=LineString -o LineStringCoordinate3DFixedPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3DM -D"TestTuple0=(x: 1.001, y: 1.001, z: 1.001, m: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, z: 2.002, m: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -DGeometryType=LineString -o LineStringCoordinate3DMFixedPrecisionTests.swift CoordinateCollectionTests.swift.gyb

# LinearRing FloatingPrecision

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2D -D"TestTuple0=(x: 1.0, y: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0)" -D"Precision=FloatingPrecision()" -DGeometryType=LinearRing -o LinearRingCoordinate2DFloatingPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2DM -D"TestTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"Precision=FloatingPrecision()" -DGeometryType=LinearRing -o LinearRingCoordinate2DMFloatingPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3D -D"TestTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"Precision=FloatingPrecision()" -DGeometryType=LinearRing -o LinearRingCoordinate3DFloatingPrecisionTests.swift CoordinateCollectionTests.swift.gyb


../bin/gyb --line-directive '' -DCoordinateType=Coordinate3DM -D"TestTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"Precision=FloatingPrecision()" -DGeometryType=LinearRing -o LinearRingCoordinate3DMFloatingPrecisionTests.swift CoordinateCollectionTests.swift.gyb

#LinearRing FixedPrecision

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2D -D"TestTuple0=(x: 1.001, y: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -DGeometryType=LinearRing -o LinearRingCoordinate2DFixedPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2DM -D"TestTuple0=(x: 1.001, y: 1.001, m: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, m: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -DGeometryType=LinearRing -o LinearRingCoordinate2DMFixedPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3D -D"TestTuple0=(x: 1.001, y: 1.001, z: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, z: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -DGeometryType=LinearRing -o LinearRingCoordinate3DFixedPrecisionTests.swift CoordinateCollectionTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3DM -D"TestTuple0=(x: 1.001, y: 1.001, z: 1.001, m: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, z: 2.002, m: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -DGeometryType=LinearRing -o LinearRingCoordinate3DMFixedPrecisionTests.swift CoordinateCollectionTests.swift.gyb

# MultiPoint FloatingPrecision

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2D -D"TestTuple0=(x: 1.0, y: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0)" -D"Precision=FloatingPrecision()" -o MultiPointCoordinate2DFloatingPrecisionTests.swift MultiPointTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2DM -D"TestTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"Precision=FloatingPrecision()" -o MultiPointCoordinate2DMFloatingPrecisionTests.swift MultiPointTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3D -D"TestTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"Precision=FloatingPrecision()" -o MultiPointCoordinate3DFloatingPrecisionTests.swift MultiPointTests.swift.gyb


../bin/gyb --line-directive '' -DCoordinateType=Coordinate3DM -D"TestTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"TestTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"Precision=FloatingPrecision()" -o MultiPointCoordinate3DMFloatingPrecisionTests.swift MultiPointTests.swift.gyb

#MultiPOint FixedPrecision

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2D -D"TestTuple0=(x: 1.001, y: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -o MultiPointCoordinate2DFixedPrecisionTests.swift MultiPointTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate2DM -D"TestTuple0=(x: 1.001, y: 1.001, m: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, m: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, m: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -o MultiPointCoordinate2DMFixedPrecisionTests.swift MultiPointTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3D -D"TestTuple0=(x: 1.001, y: 1.001, z: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, z: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -o MultiPointCoordinate3DFixedPrecisionTests.swift MultiPointTests.swift.gyb

../bin/gyb --line-directive '' -DCoordinateType=Coordinate3DM -D"TestTuple0=(x: 1.001, y: 1.001, z: 1.001, m: 1.001)" -D"TestTuple1=(x: 2.002, y: 2.002, z: 2.002, m: 2.002)" -D"ExpectedTuple0=(x: 1.0, y: 1.0, z: 1.0, m: 1.0)" -D"ExpectedTuple1=(x: 2.0, y: 2.0, z: 2.0, m: 2.0)" -D"Precision=FixedPrecision(scale: 100)" -o MultiPointCoordinate3DMFixedPrecisionTests.swift MultiPointTests.swift.gyb
