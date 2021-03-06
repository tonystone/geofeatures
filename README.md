> **Note**: GeoFeatures is currently being rewritten in pure Swift.  This project will continue to be maintained until the production release of the Swift version.  
>
> Please see [https://github.com/tonystone/geofeatures2](https://github.com/tonystone/geofeatures2) for the Swift rewrite.

# GeoFeatures ![license: Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-lightgray.svg?style=flat)

<a href="https://github.com/tonystone/geofeatures/" target="_blank">
    <img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-lightgray.svg?style=flat" alt="Platforms: iOS | macOS" />
</a>
<a href="http://cocoadocs.org/docsets/geofeatures" target="_blank">
   <img src="https://img.shields.io/cocoapods/v/GeoFeatures.svg?style=flat" alt="Version"/>
</a>
<a href="https://travis-ci.org/tonystone/geofeatures" target="_blank">
   <img src="https://travis-ci.org/tonystone/geofeatures.svg?branch=master" alt="Build Status"/>
</a>
<a href="https://codecov.io/gh/tonystone/geofeatures">
  <img src="https://codecov.io/gh/tonystone/GeoFeatures/branch/master/graph/badge.svg" alt="Codecov" />
</a>
<a href="https://github.com/tonystone/geofeatures/" target="_blank">
    <img src="https://img.shields.io/cocoapods/dt/GeoFeatures.svg?style=flat" alt="Downloads">
</a>



## Introduction

GeoFeatures is a lightweight, high performance geometry library for Objective-C.  It supports the full
 set of geometric primitives such as Point, Polygon, and LineString as well as collection classes such as MultiPoint, MultiPolygon,and MultiLineString.

![Inheritance Diagram](Documentation/GeoFeatures-Inheritance-Diagram.png)

## Features

- [x] Easy to use.
- [x] Point, MultiPoint, LineString, MultiLineString, Polygon, MultiPolygon, Box and GeometryCollection implementations.
- [x] Area, Length, BoundingBox, Centroid, Perimeter, Intersects, Intersection, Difference, Union, and Within (point in polygon) algorithms.  More coming soon.
- [x] Immutable and mutable versions of all classes (e.g. `GFPolygon` and `GFMutablePolygon`).
- [x] [WKT (Well-Known-Text)](https://en.wikipedia.org/wiki/Well-known_text) input and output.
- [x] [GeoJSON](http://geojson.org/) input and output.
- [x] MapKit representations and drawing.
- [x] Indexed Subscripting support for all collection types (e.g. `GEPoint * point = multiPoint[0]`).
- [x] **Swift**: supports direct use in Swift applications.
- [x] CocoaPod framework support (compile as Objective-C framework or static lib).
- [x] Open Sourced under the the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).
- [x] Comprehensive doxygen documentation of the library available at [github.io](http://tonystone.github.io/geofeatures).
- [x] Implemented based on the popular and fast open source C++ boost geometry library.
 
## Documentation

The doxygen documentation is online available at [github.io](http://tonystone.github.io/geofeatures).

## Sources and Binaries

You can find the latest sources and binaries on [github](https://github.com/tonystone/geofeatures).

## Communication and Contributions

- If you **found a bug**, _and can provide steps to reliably reproduce it_, [open an issue](https://github.com/tonystone/geofeatures/issues).
- If you **have a feature request**, [open an issue](https://github.com/tonystone/geofeatures/issues).
- If you **want to contribute**
   - Fork it! [GeoFeatures repository](https://github.com/tonystone/geofeatures)
   - Create your feature branch: `git checkout -b my-new-feature`
   - Commit your changes: `git commit -am 'Add some feature'`
   - Push to the branch: `git push origin my-new-feature`
   - Submit a pull request :-)

## Installation

GeoFeatures is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GeoFeatures"
```

See the ["Using CocoaPods"](https://guides.cocoapods.org/using/using-cocoapods.html) guide for more information.

## Minimum Requirements

Build Environment

| Platform | Xcode |
|:--------:|:-----:|
| OSX      | 10.1 |

Minimum Runtime Version

| iOS |  OS X |
|:---:|:-----:|
| 8.0 | 10.10 | 

## Author

Tony Stone ([https://github.com/tonystone](https://github.com/tonystone))

## License

GeoFeatures is released under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

The embedded Boost library is released under the [Boost Software License, Version 1.0](http://www.boost.org/users/license.html)
