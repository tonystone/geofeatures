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
    case THREEDIMENSIONAL               = "z"
    case MEASURED                       = "m"
    case EMPTY                          = "empty"
    case POINT                          = "point"
    case LINESTRING                     = "linestring"
    case LINEARRING                     = "linearring"
    case POLYGON                        = "polygon"
    case MULTIPOINT                     = "multipoint"
    case MULTILINESTRING                = "multilinestring"
    case MULTIPOLYGON                   = "multipolygon"
    case GEOMETRYCOLLECTION             = "geometrycollection"
}

/**
 TODO: Full header class doc with examples
 */
public class WKTWriter<CoordinateType : protocol<Coordinate, TupleConvertable>>  {
    
    public init() {
    }
    
    /**
     TODO: Full header func doc for read
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
            
            return self.pointTaggedText(point)

        case let lineString as LineString<CoordinateType>:
            
            return self.lineStringTaggedText(lineString)
            
        case let linearRing as LinearRing<CoordinateType>:
            
            return self.linearRingTaggedText(linearRing)
        
        case let polygon as Polygon<CoordinateType>:
            
            return self.polygonTaggedText(polygon)
        
        case let multiPolygon as MultiPolygon<CoordinateType>:
            
            return self.multiPolygonTaggedText(multiPolygon)
            
        case let multiLineString as MultiLineString<CoordinateType>:
            
            return self.multiLineStringTaggedText(multiLineString)
            
        case let multiPolygon as MultiPolygon<CoordinateType>:
            
            return self.multiPolygonTaggedText(multiPolygon)
            
        case let geometryCollection as GeometryCollection:
            
            return self.geometryCollectionTaggedText(geometryCollection)
            
        default:
            return ""
        }
    }

    // BNF: <point tagged text> ::= point <point text>
    private func pointTaggedText(point: Point<CoordinateType>) -> String  {
        
        return  Token.POINT.rawValue + Token.SINGLE_SPACE.rawValue + zmText(point.coordinate) + pointText(point)
    }
    
    // BNF: <point text> ::= <empty set> | <left paren> <point> <right paren>
    private func pointText(point: Point<CoordinateType>) -> String  {
        
        if point.isEmpty() {
            return Token.EMPTY.rawValue
        }
        return Token.LEFT_PAREN.rawValue + self.coordinateText(point.coordinate) + Token.RIGHT_PAREN.rawValue
    }
    
    // BNF: <linestring tagged text> ::= linestring <linestring text>
    private func lineStringTaggedText(lineString: LineString<CoordinateType>) -> String {
        
        return  Token.LINESTRING.rawValue + Token.SINGLE_SPACE.rawValue + lineStringText(lineString)
    }
    
    // BNF: <linestring text> ::= <empty set> | <left paren> <point> {<comma> <point>}* <right paren>
    private func lineStringText(lineString: LineString<CoordinateType>) -> String {
        
        if lineString.isEmpty() {
            return Token.EMPTY.rawValue
        }
        
        var lineStringText = Token.LEFT_PAREN.rawValue
        
        for index in 0..<lineString.count {
            let coordinate = lineString[index]
            
            if (index > 0) {
                lineStringText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            lineStringText += self.coordinateText(coordinate)
        }
        lineStringText += Token.RIGHT_PAREN.rawValue
        
        return lineStringText
    }
    
    // BNF: None defined by OGC
    private func linearRingTaggedText(linearRing: LinearRing<CoordinateType>) -> String {
        
        return Token.LINEARRING.rawValue + Token.SINGLE_SPACE.rawValue + linearRingText(linearRing)
    }
    
    // BNF: None defined by OGC
    private func linearRingText(linearRing: LinearRing<CoordinateType>) -> String  {
        if linearRing.isEmpty() {
            return Token.EMPTY.rawValue
        }
        linearRing.generate()
        
        var linearRingText = Token.LEFT_PAREN.rawValue
        
        for index in 0..<linearRing.count {
            let coordinate = linearRing[index]
            
            if (index > 0) {
                linearRingText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            linearRingText += self.coordinateText(coordinate)
        }
        linearRingText += Token.RIGHT_PAREN.rawValue
        
        return linearRingText
    }
    
    // BNF: <polygon tagged text> ::= polygon <polygon text>
    private func polygonTaggedText(polygon: Polygon<CoordinateType> ) -> String {
        
        return Token.POLYGON.rawValue + Token.SINGLE_SPACE.rawValue + polygonText(polygon)
    }
    
    // BNF: <polygon text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    private func polygonText(polygon: Polygon<CoordinateType> ) -> String {
        
        if polygon.isEmpty() {
            return Token.EMPTY.rawValue
        }
        
        var polygonText = Token.LEFT_PAREN.rawValue + linearRingText(polygon.outerRing)

        for index in 0..<polygon.innerRings.count {

            if (index < polygon.innerRings.count) {
                polygonText += Token.COMMA.rawValue + Token.SINGLE_SPACE.rawValue
            }
            polygonText += linearRingText(polygon.innerRings[index])
        }
        
        polygonText += Token.RIGHT_PAREN.rawValue

        return polygonText
    }
    
    // BNF: <multipoint tagged text> ::= multipoint <multipoint text>
    private func multiPointTaggedText(multiPolygon: MultiPoint<CoordinateType>) -> String {
        return ""
    }
    
    // BNF: <multipoint text> ::= <empty set> | <left paren> <point text> {<comma> <point text>}* <right paren>
    private func multiPointText(multiPolygon: MultiPoint<CoordinateType>) -> String {
        return ""
    }
    
    // BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
    private func multiLineStringTaggedText(multiLineString: MultiLineString<CoordinateType> ) -> String {
        return ""
    }
    
    // BNF: <multilinestring text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    private func multiLineStringText(multiLineString: MultiLineString<CoordinateType> ) -> String {
        return ""
    }
    
    // BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
    private func multiPolygonTaggedText(multiPolygon: MultiPolygon<CoordinateType> ) -> String {
        return ""
    }
    
    // BNF: <multipolygon text> ::= <empty set> | <left paren> <polygon text> {<comma> <polygon text>}* <right paren>
    private func multiPolygonText(multiPolygon: MultiPolygon<CoordinateType> ) -> String  {
        return ""
    }
    
    // BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
    private func geometryCollectionTaggedText(geometryCollection: GeometryCollection) -> String {
        return ""
    }
    
    // BNF: <geometrycollection text> ::= <empty set> | <left paren> <geometry tagged text> {<comma> <geometry tagged text>}* <right paren>
    private func geometryCollectionText(geometryCollection: GeometryCollection) -> String {
        return ""
    }
    
    // BNF: <point> ::= <x> <y>
    // BNF: <point z> ::= <x> <y> <z>
    // BNF: <point m> ::= <x> <y> <m>
    // BNF: <point zm> ::= <x> <y> <z> <m>
    private func coordinateText(coordinate: CoordinateType) -> String {
        
        var coordinateText = "\(coordinate.x) \(coordinate.y)"
        
        if let coordinate = coordinate as? ThreeDimensional {
            coordinateText += " \(coordinate.z)"
        }
        
        if let coordinate = coordinate as? Measured {
            coordinateText += " \(coordinate.m)"
        }
        
        return coordinateText
    }
    
    private func zmText(coordinate: CoordinateType) -> String {
        
        var zmText = ""
        
        if let _ = coordinate as? ThreeDimensional {
            zmText += Token.THREEDIMENSIONAL.rawValue
        }
        
        if let _ = coordinate as? Measured {
            zmText += Token.MEASURED.rawValue
        }
        
        if zmText != "" {
            zmText += Token.SINGLE_SPACE.rawValue
        }
        
        return zmText
    }
}