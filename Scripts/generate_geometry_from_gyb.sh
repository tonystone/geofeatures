#!/bin/sh

#  process_geometry_gyb.sh
#  GeoFeatures
#
#  Created by Tony Stone on 3/10/16.
#  Copyright © 2016 CocoaPods. All rights reserved.

../../bin/gyb --line-directive '' -DSelf=LinearRing -o LinearRing.swift CoordinateCollection.swift.gyb

../../bin/gyb --line-directive '' -DSelf=LineString -o LineString.swift CoordinateCollection.swift.gyb

../../bin/gyb --line-directive '' -DSelf=GeometryCollection -DElement=Geometry -DCoordinateSpecialized=false -o GeometryCollection.swift GeometryCollection.swift.gyb

../../bin/gyb --line-directive '' -DSelf=MultiPoint -DElement=Point -DCoordinateSpecialized=true -o MultiPoint.swift GeometryCollection.swift.gyb

../../bin/gyb --line-directive '' -DSelf=MultiLineString -DElement=LineString -DCoordinateSpecialized=true -o MultiLineString.swift GeometryCollection.swift.gyb

../../bin/gyb --line-directive '' -DSelf=MultiPolygon -DElement=Polygon -DCoordinateSpecialized=true -o MultiPolygon.swift GeometryCollection.swift.gyb
