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
import Foundation

#if os(Linux) || os(FreeBSD)
#else
    typealias RegularExpression = NSRegularExpression
#endif

public enum ParseError : Error  {
    case unsupportedType(String)
    case unexpectedToken(String)
    case missingElement(String)
}

//private func ==(lhs: RegularExpression, rhs: RegularExpression) -> Bool {
//    return lhs.regex?.pattern == rhs.regex?.pattern
//}

private class WKT : Token, CustomStringConvertible {
    
    static let WHITE_SPACE                     = WKT("white space",         pattern:  "^[ \\t]+")
    static let SINGLE_SPACE                    = WKT("single space",        pattern:  "^ (?=[^ ])")
    static let NEW_LINE                        = WKT("\n or \r",            pattern:  "^[\\n|\\r]")
    static let COMMA                           = WKT(",",                   pattern:  "^,")
    static let LEFT_PAREN                      = WKT("(",                   pattern:  "^\\(")
    static let RIGHT_PAREN                     = WKT(")",                   pattern:  "^\\)")
    static let LEFT_BRACKET                    = WKT("[",                   pattern:  "^\\[")
    static let RIGHT_BRACKET                   = WKT("]",                   pattern:  "^\\]")
    static let LEFT_DELIMITER                  = WKT("( or [",              pattern:  "^[\\(|\\[])")
    static let RIGHT_DELIMITER                 = WKT(") or ]",              pattern:  "^[\\)|\\]])")
    static let NUMERIC_LITERAL                 = WKT("numeric literal",     pattern:  "^[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?")
    static let THREEDIMENSIONAL                = WKT("Z",                   pattern:  "^z")
    static let MEASURED                        = WKT("M",                   pattern:  "^m")
    static let EMPTY                           = WKT("EMPTY",               pattern:  "^empty")
    static let POINT                           = WKT("POINT",               pattern:  "^point")
    static let LINESTRING                      = WKT("LINESTRING",          pattern:  "^linestring")
    static let LINEARRING                      = WKT("LINEARRING",          pattern:  "^linearring")
    static let POLYGON                         = WKT("POLYGON",             pattern:  "^polygon")
    static let MULTIPOINT                      = WKT("MULTIPOINT",          pattern:  "^multipoint")
    static let MULTILINESTRING                 = WKT("MULTILINESTRING",     pattern:  "^multilinestring")
    static let MULTIPOLYGON                    = WKT("MULTIPOLYGON",        pattern:  "^multipolygon")
    static let GEOMETRYCOLLECTION              = WKT("GEOMETRYCOLLECTION",  pattern:  "^geometrycollection")

    init(_ description: String, pattern value: StringLiteralType)  {
        self.description = description
        self.pattern     = value
    }
    
    func match(_ string: String, matchRange: Range<String.Index>) -> Range<String.Index>? {
        return string.range(of: self.pattern, options: [.regularExpression, .caseInsensitive], range: matchRange, locale: Locale(identifier: "en_US"))
    }
    
    func isNewLine() -> Bool {
        return self.description == WKT.NEW_LINE.description
    }
    
    var description: String
    var pattern: String
}

/**
    TODO: Full header class doc with examples
 */
open class WKTReader<CoordinateType : Coordinate & CopyConstructable & _ArrayConstructable> {
    
    fileprivate let crs: CoordinateReferenceSystem
    fileprivate let precision: Precision
    
    public init(precision: Precision = defaultPrecision, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem) {
        self.crs = coordinateReferenceSystem
        self.precision = precision
    }

    /**
        TODO: Full header func doc for read
     */
    open func read(wkt: String) throws -> Geometry {
            
        let tokenizer = Tokenizer<WKT>(string: wkt)

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
        throw ParseError.unsupportedType(wkt)
    }

    // BNF: <point tagged text> ::= point <point text>
    fileprivate func pointTaggedText(_ tokenizer:  Tokenizer<WKT>) throws -> Point<CoordinateType> {

        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try pointText(tokenizer)
    }

    // BNF: <point text> ::= <empty set> | <left paren> <point> <right paren>
    fileprivate func pointText(_ tokenizer: Tokenizer<WKT>) throws -> Point<CoordinateType> {
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        let coordinate = try self.coordinate(tokenizer)
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return Point<CoordinateType>(coordinate: coordinate, precision: precision, coordinateReferenceSystem: crs)
    }

    // BNF: <linestring tagged text> ::= linestring <linestring text>
    fileprivate func lineStringTaggedText(_ tokenizer:  Tokenizer<WKT>) throws -> LineString<CoordinateType> {
        
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try lineStringText(tokenizer)
    }

    // BNF: <linestring text> ::= <empty set> | <left paren> <point> {<comma> <point>}* <right paren>
    fileprivate func lineStringText(_ tokenizer: Tokenizer<WKT>) throws -> LineString<CoordinateType> {
        
        if tokenizer.accept(.EMPTY) != nil {
            return LineString<CoordinateType>(precision: precision, coordinateReferenceSystem: crs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var coordinates = [CoordinateType]()
        
        var done = false
        
        repeat {
            coordinates.append(try self.coordinate(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return LineString<CoordinateType>(elements: coordinates, precision: precision, coordinateReferenceSystem: crs)
    }

    // BNF: None defined by OGC
    fileprivate func linearRingTaggedText(_ tokenizer:  Tokenizer<WKT>) throws -> LinearRing<CoordinateType> {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try linearRingText(tokenizer)
    }
    
    // BNF: None defined by OGC
    fileprivate func linearRingText(_ tokenizer: Tokenizer<WKT>) throws -> LinearRing<CoordinateType> {
        
        if tokenizer.accept(.EMPTY) != nil {
            return LinearRing<CoordinateType>(precision: precision, coordinateReferenceSystem: crs)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var coordinates = [CoordinateType]()
        
        var done = false
        
        repeat {
            coordinates.append(try self.coordinate(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return LinearRing<CoordinateType>(elements: coordinates, precision: precision, coordinateReferenceSystem: crs)
    }
    
    
    // BNF: <polygon tagged text> ::= polygon <polygon text>
    fileprivate func polygonTaggedText(_ tokenizer:  Tokenizer<WKT>) throws -> Polygon<CoordinateType> {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try polygonText(tokenizer)
    }

    // BNF: <polygon text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    fileprivate func polygonText(_ tokenizer: Tokenizer<WKT>) throws -> Polygon<CoordinateType> {
        
        if tokenizer.accept(.EMPTY) != nil {
            return Polygon<CoordinateType>(precision: precision, coordinateReferenceSystem: crs)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        let outerRing = try self.linearRingText(tokenizer)
        
        if tokenizer.accept(.RIGHT_PAREN) != nil {
            return Polygon<CoordinateType>(outerRing: outerRing, innerRings: [])
        }
    
        if tokenizer.accept(.COMMA) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .COMMA))
        }
        
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        
        var innerRings = [LinearRing<CoordinateType>]()
        
        var done = false
        
        repeat {
            innerRings.append(try self.linearRingText(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        return Polygon<CoordinateType>(outerRing: outerRing, innerRings: innerRings)
    }

    // BNF: <multipoint tagged text> ::= multipoint <multipoint text>
    fileprivate func multiPointTaggedText(_ tokenizer:  Tokenizer<WKT>) throws -> MultiPoint<CoordinateType> {
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try multiPointText(tokenizer)
    }
    
    // BNF: <multipoint text> ::= <empty set> | <left paren> <point text> {<comma> <point text>}* <right paren>
    fileprivate func multiPointText(_ tokenizer: Tokenizer<WKT>) throws -> MultiPoint<CoordinateType> {
        
        if tokenizer.accept(.EMPTY) != nil {
            return MultiPoint<CoordinateType>(precision: precision, coordinateReferenceSystem: crs)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var elements = [Point<CoordinateType>]()
        
        var done = false
        
        repeat {
            elements.append(try self.pointText(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return MultiPoint<CoordinateType>(elements: elements, precision: precision, coordinateReferenceSystem: crs)
    }
    
    // BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
    fileprivate func multiLineStringTaggedText(_ tokenizer:  Tokenizer<WKT>) throws -> MultiLineString<CoordinateType> {
        
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try multiLineStringText(tokenizer)
    }
    
    // BNF: <multilinestring text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    fileprivate func multiLineStringText(_ tokenizer: Tokenizer<WKT>) throws -> MultiLineString<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return MultiLineString<CoordinateType>(precision: precision, coordinateReferenceSystem: crs)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }
        
        var elements = [LineString<CoordinateType>]()
        var done     = false
        
        repeat {
            elements.append(try self.lineStringText(tokenizer))
            
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return MultiLineString<CoordinateType>(elements: elements, precision: precision, coordinateReferenceSystem: crs)
    }
    
    // BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
    fileprivate func multiPolygonTaggedText(_ tokenizer:  Tokenizer<WKT>) throws -> MultiPolygon<CoordinateType> {

        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try multiPolygonText(tokenizer)
    }

    // BNF: <multipolygon text> ::= <empty set> | <left paren> <polygon text> {<comma> <polygon text>}* <right paren>
    fileprivate func multiPolygonText(_ tokenizer: Tokenizer<WKT>) throws -> MultiPolygon<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return MultiPolygon<CoordinateType>(precision: precision, coordinateReferenceSystem: crs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        var elements = [Polygon<CoordinateType>]()
        var done = false

        repeat {
            
            elements.append(try self.polygonText(tokenizer))

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }

        return MultiPolygon<CoordinateType>(elements: elements)
    }
    
    // BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
    fileprivate func geometryCollectionTaggedText(_ tokenizer:  Tokenizer<WKT>) throws -> GeometryCollection {
       
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        return try geometryCollectionText(tokenizer)
    }
    
    // BNF: <geometrycollection text> ::= <empty set> | <left paren> <geometry tagged text> {<comma> <geometry tagged text>}* <right paren>
    fileprivate func geometryCollectionText(_ tokenizer: Tokenizer<WKT>) throws -> GeometryCollection {
        
        if tokenizer.accept(.EMPTY) != nil {
            return GeometryCollection(precision: precision, coordinateReferenceSystem: crs)
        }
        
        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
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
                throw ParseError.missingElement("At least one Geometry is required unless you specify EMPTY for the GoemetryCollection")
            }
        
            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true;
            }
        } while !done
        
        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return GeometryCollection(elements: elements, precision: precision, coordinateReferenceSystem: crs)
    }

    // BNF: <point> ::= <x> <y>
    // BNF: <point z> ::= <x> <y> <z>
    // BNF: <point m> ::= <x> <y> <m>
    // BNF: <point zm> ::= <x> <y> <z> <m>
    fileprivate func coordinate(_ tokenizer: Tokenizer<WKT>) throws -> CoordinateType {
        
        var coordinates = [Double]()
        
        if let token = tokenizer.accept(.NUMERIC_LITERAL) {
            coordinates.append(Double(token)!)
        } else {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
        }
        
        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }
        
        if let token = tokenizer.accept(.NUMERIC_LITERAL) {
            coordinates.append(Double(token)!)
        } else {
            throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
        }
        
        if CoordinateType.self is ThreeDimensional {
            
            if tokenizer.accept(.SINGLE_SPACE) == nil {
                throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
            }
            
            if let token = tokenizer.accept(.NUMERIC_LITERAL) {
                coordinates.append(Double(token)!)
            } else {
                throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
            }
        }
        
        if CoordinateType.self is  Measured {
            
            if tokenizer.accept(.SINGLE_SPACE) == nil {
                throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
            }
            
            if let token = tokenizer.accept(.NUMERIC_LITERAL) {
                coordinates.append(Double(token)!)
            } else {
                throw ParseError.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
            }
        }
        return CoordinateType(array: coordinates)
    }

    fileprivate func errorMessage(_ tokenizer: Tokenizer<WKT>, expectedToken: WKT) -> String {
        return "Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column). Expected \(expectedToken) but found ->\(tokenizer.matchString)"
    }
}
