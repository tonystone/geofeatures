/*
*   WKTWriter.swift
*
*   Copyright 2016 Tony Stone
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
*   Created by Tony Stone on 3/8/16.
*/
import Swift

// Translated from BNF
private enum Token : String {
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

/**
 WKTWriter
 
 WKTWriter generates a WKT – Well-known Text – representation of a `Geometry` object.
 */
public class WKTWriter<CoordinateType : protocol<Coordinate, CopyConstructable, _ArrayConstructable>>  {
    
    public init() {}
    
    /**
     Based on the geometry passed in, converts it into a string representation as specified by
     the OGC WKT standard.
     
     - parameter geometry: A geometry type to be converted to WKT
     - returns: WKT string for supported types. If unsupported, an empty string is returned.
     - note: This method does not check the validity of the geometry.
     */
    public func write(geometry: Geometry) -> String {
        
        // BNF: <geometry tagged text> ::= <point tagged text>
        //                          | <linestring tagged text>
        //                          | <polygon tagged text>
        //                          | <triangle tagged text>
        //                          | <polyhedralsurface tagged text>
        //                          | <tin tagged text>
        //                          | <multipoint tagged text>
        //                          | <multilinestring tagged text>
        //                          | <multipolygon tagged text>
        //                          | <geometrycollection tagged text>
        //
        switch (geometry) {
        
        case let point as Point<CoordinateType>:
            return self.pointTaggedText(point: point)

        case let lineString as LineString<CoordinateType>:
            return self.lineStringTaggedText(lineString: lineString)
            
        case let linearRing as LinearRing<CoordinateType>:
            return self.linearRingTaggedText(linearRing: linearRing)
        
        case let polygon as Polygon<CoordinateType>:
            return self.polygonTaggedText(polygon: polygon)
            
        case let multiPoint as MultiPoint<CoordinateType>:
            return self.multiPointTaggedText(multiPoint: multiPoint)
        
        case let multiPolygon as MultiPolygon<CoordinateType>:
            return self.multiPolygonTaggedText(multiPolygon: multiPolygon)
            
        case let multiLineString as MultiLineString<CoordinateType>:
            return self.multiLineStringTaggedText(multiLineString: multiLineString)
            
        case let geometryCollection as GeometryCollection:
            return self.geometryCollectionTaggedText(geometryCollection: geometryCollection)
            
        default: return ""
        }
    }

    // BNF: <point tagged text> ::= point <point text>
    private func pointTaggedText(point: Point<CoordinateType>) -> String  {
        
        return Token.POINT.rawValue + Token.SINGLE_SPACE.rawValue + zmText(coordinate: point.coordinate) + pointText(point: point)
    }
    
    // BNF: <point text> ::= <empty set> | <left paren> <point> <right paren>
    private func pointText(point: Point<CoordinateType>) -> String  {
        
        return Token.LEFT_PAREN.rawValue + self.coordinateText(coordinate: point.coordinate) + Token.RIGHT_PAREN.rawValue
    }
    
    // BNF: <linestring tagged text> ::= linestring <linestring text>
    private func lineStringTaggedText(lineString: LineString<CoordinateType>) -> String {
        
        return Token.LINESTRING.rawValue + Token.SINGLE_SPACE.rawValue + lineStringText(lineString: lineString)
    }
    
    // BNF: <linestring text> ::= <empty set> | <left paren> <point> {<comma> <point>}* <right paren>
    private func lineStringText(lineString: LineString<CoordinateType>) -> String {
        
        if lineString.isEmpty() {
            return Token.EMPTY.rawValue
        }
        
        var lineStringText = Token.LEFT_PAREN.rawValue
        
        for index in 0..<lineString.count {
            if index > 0 {
                lineStringText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            lineStringText += self.coordinateText(coordinate: lineString[index])
        }
        
        lineStringText += Token.RIGHT_PAREN.rawValue
        
        return lineStringText
    }
    
    // BNF: None defined by OGC
    private func linearRingTaggedText(linearRing: LinearRing<CoordinateType>) -> String {
        
        return Token.LINEARRING.rawValue + Token.SINGLE_SPACE.rawValue + linearRingText(linearRing: linearRing)
    }
    
    // BNF: None defined by OGC
    private func linearRingText(linearRing: LinearRing<CoordinateType>) -> String  {

        if linearRing.isEmpty() {
            return Token.EMPTY.rawValue
        }
        
        var linearRingText = Token.LEFT_PAREN.rawValue
        
        for index in 0..<linearRing.count {
            if index > 0 {
                linearRingText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            linearRingText += self.coordinateText(coordinate: linearRing[index])
        }
        
        linearRingText += Token.RIGHT_PAREN.rawValue
        
        return linearRingText
    }
    
    // BNF: <polygon tagged text> ::= polygon <polygon text>
    private func polygonTaggedText(polygon: Polygon<CoordinateType> ) -> String {
        
        return Token.POLYGON.rawValue + Token.SINGLE_SPACE.rawValue + polygonText(polygon: polygon)
    }
    
    // BNF: <polygon text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    private func polygonText(polygon: Polygon<CoordinateType> ) -> String {
        
        if polygon.isEmpty() {
            return Token.EMPTY.rawValue
        }
        
        var polygonText = Token.LEFT_PAREN.rawValue + linearRingText(linearRing: polygon.outerRing)

        for index in 0..<polygon.innerRings.count {
            if (index < polygon.innerRings.count) {
                polygonText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            polygonText += linearRingText(linearRing: polygon.innerRings[index])
        }
        
        polygonText += Token.RIGHT_PAREN.rawValue

        return polygonText
    }
    
    // BNF: <multipoint tagged text> ::= multipoint <multipoint text>
    private func multiPointTaggedText(multiPoint: MultiPoint<CoordinateType>) -> String {
        
        return Token.MULTIPOINT.rawValue + Token.SINGLE_SPACE.rawValue + multiPointText(multiPoint: multiPoint)
    }
    
    // BNF: <multipoint text> ::= <empty set> | <left paren> <point text> {<comma> <point text>}* <right paren>
    private func multiPointText(multiPoint: MultiPoint<CoordinateType>) -> String {
        
        if multiPoint.isEmpty() {
            return Token.EMPTY.rawValue
        }
        
        var multiPointText = Token.LEFT_PAREN.rawValue
        
        for index in 0..<multiPoint.count {
            if index > 0 {
                multiPointText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            multiPointText += pointText(point: multiPoint[index])
        }
        
        return multiPointText + Token.RIGHT_PAREN.rawValue
    }
    
    // BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
    private func multiLineStringTaggedText(multiLineString: MultiLineString<CoordinateType> ) -> String {
        
        return Token.MULTILINESTRING.rawValue + Token.SINGLE_SPACE.rawValue +  multiLineStringText(multiLineString: multiLineString)
    }
    
    // BNF: <multilinestring text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    private func multiLineStringText(multiLineString: MultiLineString<CoordinateType>) -> String {
        
        if multiLineString.isEmpty() {
            return Token.EMPTY.rawValue
        }
        
        var multiLineStringText = Token.LEFT_PAREN.rawValue
        
        for index in 0..<multiLineString.count {
            if index > 0 {
                multiLineStringText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            multiLineStringText += lineStringText(lineString: multiLineString[index])
        }
        
        return multiLineStringText + Token.RIGHT_PAREN.rawValue
    }
    
    // BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
    private func multiPolygonTaggedText(multiPolygon: MultiPolygon<CoordinateType> ) -> String {
        return Token.MULTIPOLYGON.rawValue + Token.SINGLE_SPACE.rawValue + multiPolygonText(multiPolygon: multiPolygon)
    }
    
    // BNF: <multipolygon text> ::= <empty set> | <left paren> <polygon text> {<comma> <polygon text>}* <right paren>
    private func multiPolygonText(multiPolygon: MultiPolygon<CoordinateType> ) -> String  {
        
        if multiPolygon.isEmpty() {
            return Token.EMPTY.rawValue
        }
        
        var multiPolygonText = Token.LEFT_PAREN.rawValue
        
        for index in 0..<multiPolygon.count {
            if index > 0 {
                multiPolygonText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            multiPolygonText += polygonText(polygon: multiPolygon[index])
        }
        
        return multiPolygonText + Token.RIGHT_PAREN.rawValue
    }
    
    // BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
    private func geometryCollectionTaggedText(geometryCollection: GeometryCollection) -> String {
        return Token.GEOMETRYCOLLECTION.rawValue + Token.SINGLE_SPACE.rawValue + geometryCollectionText(geometryCollection: geometryCollection)
    }
    
    // BNF: <geometrycollection text> ::= <empty set> | <left paren> <geometry tagged text> {<comma> <geometry tagged text>}* <right paren>
    private func geometryCollectionText(geometryCollection: GeometryCollection) -> String {
        
        var geometryCollectionText = Token.LEFT_PAREN.rawValue
        
        for index in 0..<geometryCollection.count {
            
            if index > 0 {
                geometryCollectionText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            geometryCollectionText += write(geometry: geometryCollection[index])
        }
        
        return geometryCollectionText + Token.RIGHT_PAREN.rawValue
    }
    
    // BNF: <point> ::= <x> <y>
    // BNF: <point z> ::= <x> <y> <z>
    // BNF: <point m> ::= <x> <y> <m>
    // BNF: <point zm> ::= <x> <y> <z> <m>
    private func coordinateText(coordinate: CoordinateType) -> String {
        
        var coordinateText = "\(coordinate.x) \(coordinate.y)"
        
        if let coordinate = coordinate as? ThreeDimensional {
            coordinateText += Token.SINGLE_SPACE.rawValue + "\(coordinate.z)"
        }
        
        if let coordinate = coordinate as? Measured {
            coordinateText += Token.SINGLE_SPACE.rawValue + "\(coordinate.m)"
        }
        
        return coordinateText
    }
    
    private func zmText(coordinate: CoordinateType) -> String {
        
        var zmText = ""
        
        if coordinate is ThreeDimensional {
            zmText += Token.THREEDIMENSIONAL.rawValue
        }
        
        if coordinate is Measured {
            zmText += Token.MEASURED.rawValue
        }
        
        if zmText != "" {
            zmText += Token.SINGLE_SPACE.rawValue
        }
        
        return zmText
    }
}