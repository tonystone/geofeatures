# Change Log
All significant changes to this project will be documented in this file.

## [1.8.0](https://github.com/tonystone/geofeatures/tree/1.8.0)

#### Changed
- Now requires Xcode 10.1 to build.
- Now requires Cocoapods 1.6.0

#### Fixed
- Nullability of GFLineString `- (GFPoint *) firstPoint` and `- (GFPoint *) lastPoint` changed to  `_Nullable` return type.
- Nullability of GFGeometry `- (GFPoint *) firstGeometry` and `- (GFPoint *) lastGeometry` changed to  `_Nullable` return type.
