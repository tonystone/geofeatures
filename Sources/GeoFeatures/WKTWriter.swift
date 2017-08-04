///
///  WKTWriter.swift
///
///  Copyright (c) 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 3/8/2016.
///
import Swift

/// Translated from BNF
private enum WKT: String {
    case SINGLE_SPACE                   = " "
    case NEW_LINE                       = "\\n"
    case COMMA                          = ","
    case LEFT_PAREN                     = "("
    case RIGHT_PAREN                    = ")"
    case LEFT_BRACKET                   = "["
    case RIGHT_BRACKET                  = "]"
    case THREEDIMENSIONAL               = "Z"
    case MEASURED                       = "M"
    case EMPTY                          = "EMPTY"
    case POINT                          = "POINT"
    case LINESTRING                     = "LINESTRING"
    case LINEARRING                     = "LINEARRING"
    case POLYGON                        = "POLYGON"
    case MULTIPOINT                     = "MULTIPOINT"
    case MULTILINESTRING                = "MULTILINESTRING"
    case MULTIPOLYGON                   = "MULTIPOLYGON"
    case GEOMETRYCOLLECTION             = "GEOMETRYCOLLECTION"
}

///
/// WKTWriter
///
/// WKTWriter generates a WKT – Well-known Text – representation of a `Geometry` object.
///
public class WKTWriter<CoordinateType: Coordinate & CopyConstructable & _ArrayConstructable> {

    public init() {}

    ///
    /// Based on the geometry passed in, converts it into a string representation as specified by
    /// the OGC WKT standard.
    ///
    /// - parameter geometry: A geometry type to be converted to WKT
    /// - returns: WKT string for supported types. If unsupported, an empty string is returned.
    /// - note: This method does not check the validity of the geometry.
    ///
    public func write(_ geometry: Geometry) -> String {

        /// BNF: <geometry tagged text> ::= <point tagged text>
        ///                          | <linestring tagged text>
        ///                          | <polygon tagged text>
        ///                          | <triangle tagged text>
        ///                          | <polyhedralsurface tagged text>
        ///                          | <tin tagged text>
        ///                          | <multipoint tagged text>
        ///                          | <multilinestring tagged text>
        ///                          | <multipolygon tagged text>
        ///                          | <geometrycollection tagged text>
        ///
        switch geometry {

        case let point as Point<CoordinateType>:
            return self.pointTaggedText(point)

        case let lineString as LineString<CoordinateType>:
            return self.lineStringTaggedText(lineString)

        case let linearRing as LinearRing<CoordinateType>:
            return self.linearRingTaggedText(linearRing)

        case let polygon as Polygon<CoordinateType>:
            return self.polygonTaggedText(polygon)

        case let multiPoint as MultiPoint<CoordinateType>:
            return self.multiPointTaggedText(multiPoint)

        case let multiPolygon as MultiPolygon<CoordinateType>:
            return self.multiPolygonTaggedText(multiPolygon)

        case let multiLineString as MultiLineString<CoordinateType>:
            return self.multiLineStringTaggedText(multiLineString)

        case let geometryCollection as GeometryCollection:
            return self.geometryCollectionTaggedText(geometryCollection)

        default: return ""
        }
    }

    /// BNF: <point tagged text> ::= point <point text>
    fileprivate func pointTaggedText(_ point: Point<CoordinateType>) -> String {

        return WKT.POINT.rawValue + WKT.SINGLE_SPACE.rawValue + zmText(point.coordinate) + pointText(point)
    }

    /// BNF: <point text> ::= <empty set> | <left paren> <point> <right paren>
    fileprivate func pointText(_ point: Point<CoordinateType>) -> String {

        return WKT.LEFT_PAREN.rawValue + self.coordinateText(point.coordinate) + WKT.RIGHT_PAREN.rawValue
    }

    /// BNF: <linestring tagged text> ::= linestring <linestring text>
    fileprivate func lineStringTaggedText(_ lineString: LineString<CoordinateType>) -> String {

        return WKT.LINESTRING.rawValue + WKT.SINGLE_SPACE.rawValue + lineStringText(lineString)
    }

    /// BNF: <linestring text> ::= <empty set> | <left paren> <point> {<comma> <point>}* <right paren>
    fileprivate func lineStringText(_ lineString: LineString<CoordinateType>) -> String {

        if lineString.isEmpty() {
            return WKT.EMPTY.rawValue
        }

        var lineStringText = WKT.LEFT_PAREN.rawValue

        for index in 0..<lineString.count {
            if index > 0 {
                lineStringText += WKT.COMMA.rawValue + WKT.SINGLE_SPACE.rawValue
            }
            lineStringText += self.coordinateText(lineString[index])
        }

        lineStringText += WKT.RIGHT_PAREN.rawValue

        return lineStringText
    }

    /// BNF: None defined by OGC
    fileprivate func linearRingTaggedText(_ linearRing: LinearRing<CoordinateType>) -> String {

        return WKT.LINEARRING.rawValue + WKT.SINGLE_SPACE.rawValue + linearRingText(linearRing)
    }

    /// BNF: None defined by OGC
    fileprivate func linearRingText(_ linearRing: LinearRing<CoordinateType>) -> String {

        if linearRing.isEmpty() {
            return WKT.EMPTY.rawValue
        }

        var linearRingText = WKT.LEFT_PAREN.rawValue

        for index in 0..<linearRing.count {
            if index > 0 {
                linearRingText += WKT.COMMA.rawValue + WKT.SINGLE_SPACE.rawValue
            }
            linearRingText += self.coordinateText(linearRing[index])
        }

        linearRingText += WKT.RIGHT_PAREN.rawValue

        return linearRingText
    }

    /// BNF: <polygon tagged text> ::= polygon <polygon text>
    fileprivate func polygonTaggedText(_ polygon: Polygon<CoordinateType> ) -> String {

        return WKT.POLYGON.rawValue + WKT.SINGLE_SPACE.rawValue + polygonText(polygon)
    }

    /// BNF: <polygon text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    fileprivate func polygonText(_ polygon: Polygon<CoordinateType> ) -> String {

        if polygon.isEmpty() {
            return WKT.EMPTY.rawValue
        }

        var polygonText = WKT.LEFT_PAREN.rawValue + linearRingText(polygon.outerRing)

        for index in 0..<polygon.innerRings.count {

            if index < polygon.innerRings.count {
                polygonText += WKT.COMMA.rawValue + WKT.SINGLE_SPACE.rawValue
            }
            polygonText += linearRingText(polygon.innerRings[index])
        }

        polygonText += WKT.RIGHT_PAREN.rawValue

        return polygonText
    }

    /// BNF: <multipoint tagged text> ::= multipoint <multipoint text>
    fileprivate func multiPointTaggedText(_ multiPoint: MultiPoint<CoordinateType>) -> String {

        return WKT.MULTIPOINT.rawValue + WKT.SINGLE_SPACE.rawValue + multiPointText(multiPoint)
    }

    /// BNF: <multipoint text> ::= <empty set> | <left paren> <point text> {<comma> <point text>}* <right paren>
    fileprivate func multiPointText(_ multiPoint: MultiPoint<CoordinateType>) -> String {

        if multiPoint.isEmpty() {
            return WKT.EMPTY.rawValue
        }

        var multiPointText = WKT.LEFT_PAREN.rawValue

        for index in 0..<multiPoint.count {
            if index > 0 {
                multiPointText += WKT.COMMA.rawValue + WKT.SINGLE_SPACE.rawValue
            }
            multiPointText += pointText(multiPoint[index])
        }

        return multiPointText + WKT.RIGHT_PAREN.rawValue
    }

    /// BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
    fileprivate func multiLineStringTaggedText(_ multiLineString: MultiLineString<CoordinateType> ) -> String {

        return WKT.MULTILINESTRING.rawValue + WKT.SINGLE_SPACE.rawValue +  multiLineStringText(multiLineString)
    }

    /// BNF: <multilinestring text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    fileprivate func multiLineStringText(_ multiLineString: MultiLineString<CoordinateType>) -> String {

        if multiLineString.isEmpty() {
            return WKT.EMPTY.rawValue
        }

        var multiLineStringText = WKT.LEFT_PAREN.rawValue

        for index in 0..<multiLineString.count {
            if index > 0 {
                multiLineStringText += WKT.COMMA.rawValue + WKT.SINGLE_SPACE.rawValue
            }
            multiLineStringText += lineStringText(multiLineString[index])
        }

        return multiLineStringText + WKT.RIGHT_PAREN.rawValue
    }

    /// BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
    fileprivate func multiPolygonTaggedText(_ multiPolygon: MultiPolygon<CoordinateType> ) -> String {
        return WKT.MULTIPOLYGON.rawValue + WKT.SINGLE_SPACE.rawValue + multiPolygonText(multiPolygon)
    }

    /// BNF: <multipolygon text> ::= <empty set> | <left paren> <polygon text> {<comma> <polygon text>}* <right paren>
    fileprivate func multiPolygonText(_ multiPolygon: MultiPolygon<CoordinateType> ) -> String {

        if multiPolygon.isEmpty() {
            return WKT.EMPTY.rawValue
        }

        var multiPolygonText = WKT.LEFT_PAREN.rawValue

        for index in 0..<multiPolygon.count {
            if index > 0 {
                multiPolygonText += WKT.COMMA.rawValue + WKT.SINGLE_SPACE.rawValue
            }
            multiPolygonText += polygonText(multiPolygon[index])
        }

        return multiPolygonText + WKT.RIGHT_PAREN.rawValue
    }

    /// BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
    fileprivate func geometryCollectionTaggedText(_ geometryCollection: GeometryCollection) -> String {
        return WKT.GEOMETRYCOLLECTION.rawValue + WKT.SINGLE_SPACE.rawValue + geometryCollectionText(geometryCollection)
    }

    /// BNF: <geometrycollection text> ::= <empty set> | <left paren> <geometry tagged text> {<comma> <geometry tagged text>}* <right paren>
    fileprivate func geometryCollectionText(_ geometryCollection: GeometryCollection) -> String {

        var geometryCollectionText = WKT.LEFT_PAREN.rawValue

        for index in 0..<geometryCollection.count {

            if index > 0 {
                geometryCollectionText += WKT.COMMA.rawValue + WKT.SINGLE_SPACE.rawValue
            }
            geometryCollectionText += write(geometryCollection[index])
        }

        return geometryCollectionText + WKT.RIGHT_PAREN.rawValue
    }

    /// BNF: <point> ::= <x> <y>
    /// BNF: <point z> ::= <x> <y> <z>
    /// BNF: <point m> ::= <x> <y> <m>
    /// BNF: <point zm> ::= <x> <y> <z> <m>
    fileprivate func coordinateText(_ coordinate: CoordinateType) -> String {

        var coordinateText = "\(coordinate.x) \(coordinate.y)"

        if let coordinate = coordinate as? ThreeDimensional {
            coordinateText += WKT.SINGLE_SPACE.rawValue + "\(coordinate.z)"
        }

        if let coordinate = coordinate as? Measured {
            coordinateText += WKT.SINGLE_SPACE.rawValue + "\(coordinate.m)"
        }

        return coordinateText
    }

    fileprivate func zmText(_ coordinate: CoordinateType) -> String {

        var zmText = ""

        if coordinate is ThreeDimensional {
            zmText += WKT.THREEDIMENSIONAL.rawValue
        }

        if coordinate is Measured {
            zmText += WKT.MEASURED.rawValue
        }

        if zmText != "" {
            zmText += WKT.SINGLE_SPACE.rawValue
        }

        return zmText
    }
}
