#!/bin/sh

#  process_geometry_gyb.sh
#  GeoFeatures2
#
#  Created by Tony Stone on 3/10/16.
#  Copyright © 2016 CocoaPods. All rights reserved.

cd ../Geometry

../Example/bin/gyb --line-directive '' -DSelf=LinearRing -o LinearRing.swift CoordinateCollection.swift.gyb

../Example/bin/gyb --line-directive '' -DSelf=LineString -o LineString.swift CoordinateCollection.swift.gyb

../Example/bin/gyb --line-directive '' -DSelf=MultiPoint -DElement=Point -o MultiPoint.swift MultiCollection.swift.gyb

../Example/bin/gyb --line-directive '' -DSelf=MultiLineString -DElement=LineString -o MultiLineString.swift MultiCollection.swift.gyb

../Example/bin/gyb --line-directive '' -DSelf=MultiPolygon -DElement=Polygon -o MultiPolygon.swift MultiCollection.swift.gyb
