/*
 *   WKTReader.swift
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
 *   Created by Tony Stone on 2/10/16.
 */
import Swift

public enum ParseError : ErrorType  {
    case UnsupportedType(String)
    case UnexpectedToken(String)
    case MissingElement(String)
}

// Translated from BNF
private enum Token : String {
    case WHITE_SPACE                    = "[ \\t]+"
    case SINGLE_SPACE                   = " (?=[^ ])"
    case NEW_LINE                       = "[\\n|\\r]"
    case COMMA                          = ","
    case LEFT_PAREN                     = "\\("
    case RIGHT_PAREN                    = "\\)"
    case LEFT_BRACKET                   = "\\["
    case RIGHT_BRACKET                  = "\\]"
    case LEFT_DELIMITER                 = "[\\(|\\[])"
    case RIGHT_DELIMITER                = "[\\)|\\]])"
    case NUMERIC_LITERAL                = "[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?"
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
    
    func match(string: String) -> Range<String.Index>? {
        return string.rangeOfString(self.rawValue, options: [.RegularExpressionSearch, .CaseInsensitiveSearch, .AnchoredSearch])
    }
}

private class Tokenizer {
    
    var stringStream: String
    var line = 0
    var column = 0
    
    init(string: String) {
        self.stringStream = string
        if self.stringStream.characters.count > 0 {
            line = 1
            column = 1
        }
    }
    
    func accept(token: Token) -> String? {
        if let range = token.match(stringStream) {
            
            if token == .NEW_LINE {
                line += 1
                column = 1
            } else {
                column += range.count
            }
            let result = stringStream[range]
            
            stringStream.removeRange(range)
            
            return result
        }
        return nil
    }
    
    func expect(token: Token) -> Bool {
        return token.match(stringStream) != nil
    }
}

/**
    TODO: Full header class doc with examples
 */
public class WKTReader<CoordinateType : protocol<Coordinate, TupleConvertable>> {

    private let crs: CoordinateReferenceSystem
    private let precision: Precision
    
    public init(coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        self.crs = coordinateReferenceSystem
        self.precision = precision
    }

    /**
        TODO: Full header func doc for read
     */
    public func read(string: String) throws -> Geometry {
            
        let tokenizer = Tokenizer(string: string)

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
        
        // BNF: <point tagged text> ::= point <point text>
        if tokenizer.accept(.POINT) != nil {
            return try self.pointTaggedText(tokenizer)
        }
        
        // BNF: <linestring tagged text> ::= linestring <linestring text>
        if tokenizer.accept(.LINESTRING) != nil {
            return try self.lineStringTaggedText(tokenizer)
        }
        
        // Currently unsupported by OGC
        if tokenizer.accept(.LINEARRING) != nil {
            return try self.linearRingTaggedText(tokenizer)
        }
        
        // BNF: <polygon tagged text> ::= polygon <polygon text>
        if tokenizer.accept(.POLYGON) != nil {
            return try self.polygonTaggedText(tokenizer)
        }
        
        // BNF: <multipoint tagged text> ::= multipoint <multipoint text>
        if tokenizer.accept(.MULTIPOINT) != nil {
            return try self.multiPointTaggedText(tokenizer)
        }
        
        // BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
        if tokenizer.accept(.MULTILINESTRING) != nil  {
            return try self.multiLineStringTaggedText(tokenizer)
        }
        
        // BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
        if tokenizer.accept(.MULTIPOLYGON) != nil  {
            return try self.multiPolygonTaggedText(tokenizer)
        }
        
        // BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
        if tokenizer.accept(.GEOMETRYCOLLECTION) != nil {
            return try self.geometryCollectionTaggedText(tokenizer)
        }
        throw ParseError.UnsupportedType(string)
    }

    // BNF: <point tagged text> ::= point <point text>
    private func pointTaggedText(tokenizer: Tokenizer) throws -> Point<CoordinateType> {

        if tokenizer.accept(.SINGLE_SPACE) == nil {

            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try pointText(tokenizer)
    }

    // BNF: <point text> ::= <empty set> | <left paren> <point> <right paren>
    private func pointText(tokenizer: Tokenizer) throws -> Point<CoordinateType> {
    
        if tokenizer.accept(.EMPTY) != nil {
            return Point<CoordinateType>(coordinate: CoordinateType(), coordinateReferenceSystem: crs, precision: precision)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        let coordinate = try self.coordinate(tokenizer)
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return Point<CoordinateType>(coordinate: coordinate, coordinateReferenceSystem: crs, precision: precision)
    }

    // BNF: <linestring tagged text> ::= linestring <linestring text>
    private func lineStringTaggedText(tokenizer: Tokenizer) throws -> LineString<CoordinateType> {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try lineStringText(tokenizer)
    }

    // BNF: <linestring text> ::= <empty set> | <left paren> <point> {<comma> <point>}* <right paren>
    private func lineStringText(tokenizer: Tokenizer) throws -> LineString<CoordinateType> {
        
        if tokenizer.accept(.EMPTY) != nil {
            return LineString<CoordinateType>(coordinateReferenceSystem: crs, precision: precision)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var coordinates = [CoordinateType]()
        
        var done = false
        
        repeat {
            coordinates.append(try self.coordinate(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return LineString<CoordinateType>(elements: coordinates, coordinateReferenceSystem: crs, precision: precision)
    }

    // BNF: None defined by OGC
    private func linearRingTaggedText(tokenizer: Tokenizer) throws -> LinearRing<CoordinateType> {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try linearRingText(tokenizer)
    }
    
    // BNF: None defined by OGC
    private func linearRingText(tokenizer: Tokenizer) throws -> LinearRing<CoordinateType> {
        
        if tokenizer.accept(.EMPTY) != nil {
            return LinearRing<CoordinateType>(coordinateReferenceSystem: crs, precision: precision)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var coordinates = [CoordinateType]()
        
        var done = false
        
        repeat {
            coordinates.append(try self.coordinate(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return LinearRing<CoordinateType>(elements: coordinates, coordinateReferenceSystem: crs, precision: precision)
    }
    
    
    // BNF: <polygon tagged text> ::= polygon <polygon text>
    private func polygonTaggedText(tokenizer: Tokenizer) throws -> Polygon<CoordinateType> {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try polygonText(tokenizer)
    }

    // BNF: <polygon text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    private func polygonText(tokenizer: Tokenizer) throws -> Polygon<CoordinateType> {
        
        if tokenizer.accept(.EMPTY) != nil {
            
            return Polygon<CoordinateType>(coordinateReferenceSystem: crs, precision: precision)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        let outerRing = try self.linearRingText(tokenizer)
        
        if tokenizer.accept(.RIGHT_PAREN) != nil {
            
            return Polygon<CoordinateType>(outerRing: outerRing, innerRings: [])
        }
    
        if tokenizer.accept(.COMMA) == nil {
            
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .COMMA))
        }
        
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        
        var innerRings = [LinearRing<CoordinateType>]()
        
        var done = false
        
        repeat {
            innerRings.append(try self.linearRingText(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        return Polygon<CoordinateType>(outerRing: outerRing, innerRings: innerRings)
    }

    // BNF: <multipoint tagged text> ::= multipoint <multipoint text>
    private func multiPointTaggedText(tokenizer: Tokenizer) throws -> MultiPoint<CoordinateType> {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try multiPointText(tokenizer)
    }
    
    // BNF: <multipoint text> ::= <empty set> | <left paren> <point text> {<comma> <point text>}* <right paren>
    private func multiPointText(tokenizer: Tokenizer) throws -> MultiPoint<CoordinateType> {
        
        if tokenizer.accept(.EMPTY) != nil {
            return MultiPoint<CoordinateType>(coordinateReferenceSystem: crs, precision: precision)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var elements = [Point<CoordinateType>]()
        
        var done = false
        
        repeat {
            elements.append(try self.pointText(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return MultiPoint<CoordinateType>(elements: elements, coordinateReferenceSystem: crs, precision: precision)
    }
    
    // BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
    private func multiLineStringTaggedText(tokenizer: Tokenizer) throws -> MultiLineString<CoordinateType> {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try multiLineStringText(tokenizer)
    }
    
    // BNF: <multilinestring text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    private func multiLineStringText(tokenizer: Tokenizer) throws -> MultiLineString<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return MultiLineString<CoordinateType>(coordinateReferenceSystem: crs, precision: precision)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var elements = [LineString<CoordinateType>]()
        var done     = false
        
        repeat {
            elements.append(try self.lineStringText(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return MultiLineString<CoordinateType>(elements: elements, coordinateReferenceSystem: crs, precision: precision)
    }
    
    // BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
    private func multiPolygonTaggedText(tokenizer: Tokenizer) throws -> MultiPolygon<CoordinateType> {

        if tokenizer.accept(.SINGLE_SPACE) == nil {

            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try multiPolygonText(tokenizer)
    }

    // BNF: <multipolygon text> ::= <empty set> | <left paren> <polygon text> {<comma> <polygon text>}* <right paren>
    private func multiPolygonText(tokenizer: Tokenizer) throws -> MultiPolygon<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {

            return MultiPolygon<CoordinateType>(coordinateReferenceSystem: crs, precision: precision)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {

            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        var elements = [Polygon<CoordinateType>]()
        var done = false

        repeat {
            
            if tokenizer.accept(.POLYGON) == nil {
                
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .POLYGON))
            }
        
            elements.append(try self.polygonTaggedText(tokenizer))

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }

        return MultiPolygon<CoordinateType>(elements: elements)
    }
    
    // BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
    private func geometryCollectionTaggedText(tokenizer: Tokenizer) throws -> GeometryCollection {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try geometryCollectionText(tokenizer)
    }
    
    // BNF: <geometrycollection text> ::= <empty set> | <left paren> <geometry tagged text> {<comma> <geometry tagged text>}* <right paren>
    private func geometryCollectionText(tokenizer: Tokenizer) throws -> GeometryCollection {
        
        if tokenizer.accept(.EMPTY) != nil {
            return GeometryCollection(coordinateReferenceSystem: crs, precision: precision)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var elements = [Geometry]()
        var done     = false
        
        repeat {
            // BNF: <point tagged text> ::= point <point text>
            if tokenizer.accept(.POINT) != nil {
                elements.append(try self.pointTaggedText(tokenizer))
                
            // BNF: <linestring tagged text> ::= linestring <linestring text>
            } else if tokenizer.accept(.LINESTRING) != nil {
                elements.append(try self.lineStringTaggedText(tokenizer))
                
            // Currently unsupported by OGC
            } else if tokenizer.accept(.LINEARRING) != nil {
                elements.append(try self.linearRingTaggedText(tokenizer))
                
            // BNF: <polygon tagged text> ::= polygon <polygon text>
            } else if tokenizer.accept(.POLYGON) != nil {
                elements.append(try self.polygonTaggedText(tokenizer))
        
            // BNF: <multipoint tagged text> ::= multipoint <multipoint text>
            } else if tokenizer.accept(.MULTIPOINT) != nil {
                elements.append(try self.multiPointTaggedText(tokenizer))
        
            // BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
            } else if tokenizer.accept(.MULTILINESTRING) != nil  {
                elements.append(try self.multiLineStringTaggedText(tokenizer))
                
            // BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
            } else if tokenizer.accept(.MULTIPOLYGON) != nil  {
                elements.append(try self.multiPolygonTaggedText(tokenizer))
                
            // BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
            } else if tokenizer.accept(.GEOMETRYCOLLECTION) != nil {
                elements.append(try self.geometryCollectionTaggedText(tokenizer))
            } else {
                throw ParseError.MissingElement("At least one Geometry is required unless you specify EMPTY for the GoemetryCollection")
            }
        
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return GeometryCollection(elements: elements, coordinateReferenceSystem: crs, precision: precision)
    }

    // BNF: <point> ::= <x> <y>
    // BNF: <point z> ::= <x> <y> <z>
    // BNF: <point m> ::= <x> <y> <m>
    // BNF: <point zm> ::= <x> <y> <z> <m>
    private func coordinate(tokenizer: Tokenizer) throws -> CoordinateType {
        
        var coordinate = CoordinateType()
        
        if let token = tokenizer.accept(.NUMERIC_LITERAL) {
            coordinate.x = Double(token)!
        } else {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
        }
        
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        
        if let token = tokenizer.accept(.NUMERIC_LITERAL) {
            coordinate.y = Double(token)!
        } else {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
        }
        
        if var coordinate = coordinate as? ThreeDimensional {
            
            if tokenizer.accept(.SINGLE_SPACE) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
            }
            
            if let token = tokenizer.accept(.NUMERIC_LITERAL) {
                coordinate.z = Double(token)!
            } else {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
            }
        }
        
        if var coordinate = coordinate as? Measured {
            
            if tokenizer.accept(.SINGLE_SPACE) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
            }
            
            if let token = tokenizer.accept(.NUMERIC_LITERAL) {
                coordinate.m = Double(token)!
            } else {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
            }
        }
        return coordinate
    }

    private func errorMessage(tokenizer: Tokenizer, expectedToken: Token) -> String {
        return "Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column). Expected \(expectedToken) but found ->\(tokenizer.stringStream)"
    }
}