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
}

// Translated from BNF
private enum Token : String {
    case WHITE_SPACE                    = "[ \\t]+"
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

public class WKTReader<CoordinateType : protocol<Coordinate, TupleConvertable>> {

    public class func read(string: String, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem) throws -> Geometry {
            
        let tokenizer = Tokenizer(string: string)
        
        // Eat any white space before the start
        tokenizer.accept(.WHITE_SPACE)

        if tokenizer.accept(.POINT) != nil {
            
            return try self.point(tokenizer)
        }
        
        if tokenizer.accept(.LINESTRING) != nil {
            
            return try self.lineString(tokenizer)
        }
        
        if tokenizer.accept(.LINEARRING) != nil {
            
            throw ParseError.UnsupportedType(String(Token.LINEARRING))
        }
        
        if tokenizer.accept(.POLYGON) != nil {
            
            throw ParseError.UnsupportedType(String(Token.POLYGON))
        }
        
        if tokenizer.accept(.MULTIPOINT) != nil {
            
            return try self.multiPoint(tokenizer)
        }
        
        if tokenizer.accept(.MULTILINESTRING) != nil  {
            
            return try self.multiLineString(tokenizer)
        }
        
        if tokenizer.accept(.MULTIPOLYGON) != nil  {
            
            throw ParseError.UnsupportedType(String(Token.MULTIPOLYGON))
        }
        
        if tokenizer.accept(.GEOMETRYCOLLECTION) != nil {
            
            throw ParseError.UnsupportedType(String(Token.GEOMETRYCOLLECTION))
        }
        
        throw ParseError.UnsupportedType(string)
    }
    
    private class func point(tokenizer: Tokenizer) throws -> Point<CoordinateType> {
        
        // Eat any white space
        tokenizer.accept(.WHITE_SPACE)

        if tokenizer.accept(.EMPTY) != nil {
            
            return Point<CoordinateType>(coordinate: CoordinateType())
        } else {
            
            if tokenizer.accept(.LEFT_PAREN) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.LEFT_PAREN))
            }
            
            let coordinate = try self.coordinate(tokenizer)
            
            // Eat any white space
            tokenizer.accept(.WHITE_SPACE)
            
            if tokenizer.accept(.RIGHT_PAREN) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.RIGHT_PAREN))
            }
    
            return Point<CoordinateType>(coordinate: coordinate)
        }
    }
    
    private class func lineString(tokenizer: Tokenizer) throws -> LineString<CoordinateType> {
        
        // Eat any white space
        tokenizer.accept(.WHITE_SPACE)
        
        if tokenizer.accept(.EMPTY) != nil {
            
            return LineString<CoordinateType>()
        } else {
        
            if tokenizer.accept(.LEFT_PAREN) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.LEFT_PAREN))
            }
            
            var coordinates = [CoordinateType]()

            repeat {
                coordinates.append(try self.coordinate(tokenizer))
            } while tokenizer.accept(.COMMA) != nil
            
            // Eat any white space
            tokenizer.accept(.WHITE_SPACE)
            
            if tokenizer.accept(.RIGHT_PAREN) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.RIGHT_PAREN))
            }
            
            return LineString<CoordinateType>(elements: coordinates)
        }
    }

    private class func multiPoint(tokenizer: Tokenizer) throws -> MultiPoint<CoordinateType> {
        
        tokenizer.accept(.WHITE_SPACE) // Eat any white space

        if tokenizer.accept(.EMPTY) != nil {
            
            return MultiPoint<CoordinateType>()
        } else {

            if tokenizer.accept(.LEFT_PAREN) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.LEFT_PAREN))
            }

            var elements = [Point<CoordinateType>]()

            repeat {
                elements.append(try self.point(tokenizer))
            } while tokenizer.accept(.COMMA) != nil
            
            
            tokenizer.accept(.WHITE_SPACE) // Eat any white space
            
            if tokenizer.accept(.RIGHT_PAREN) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.RIGHT_PAREN))
            }
            
            return MultiPoint<CoordinateType>(elements: elements)
        }
    }
    
    private class func multiLineString(tokenizer: Tokenizer) throws -> MultiLineString<CoordinateType> {
        
        tokenizer.accept(.WHITE_SPACE) // Eat any white space
        
        if tokenizer.accept(.EMPTY) != nil {
            
            return MultiLineString<CoordinateType>()
        } else {
            
            if tokenizer.accept(.LEFT_PAREN) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.LEFT_PAREN))
            }
            
            var elements = [LineString<CoordinateType>]()
            
            repeat {
                elements.append(try self.lineString(tokenizer))
            } while tokenizer.accept(.COMMA) != nil
            
            
            tokenizer.accept(.WHITE_SPACE) // Eat any white space
            
            if tokenizer.accept(.RIGHT_PAREN) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.RIGHT_PAREN))
            }
            
            return MultiLineString<CoordinateType>(elements: elements)
        }
    }
    
    private class func coordinate(tokenizer: Tokenizer) throws -> CoordinateType {
        
        var coordinate = CoordinateType()
        
        // Eat any white space
        tokenizer.accept(.WHITE_SPACE)
        
        if let token = tokenizer.accept(.NUMERIC_LITERAL) {
            coordinate.x = Double(token)!
        } else {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.NUMERIC_LITERAL))
        }
        
        if tokenizer.accept(.WHITE_SPACE) == nil {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.WHITE_SPACE))
        }
        
        if let token = tokenizer.accept(.NUMERIC_LITERAL) {
            coordinate.y = Double(token)!
        } else {
            throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.NUMERIC_LITERAL))
        }
        
        if var coordinate = coordinate as? ThreeDimensional {
            
            if tokenizer.accept(.WHITE_SPACE) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.WHITE_SPACE))
            }
            
            if let token = tokenizer.accept(.NUMERIC_LITERAL) {
                coordinate.z = Double(token)!
            } else {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.NUMERIC_LITERAL))
            }
        }
        
        if var coordinate = coordinate as? Measured {
            
            if tokenizer.accept(.WHITE_SPACE) == nil {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.WHITE_SPACE))
            }
            
            if let token = tokenizer.accept(.NUMERIC_LITERAL) {
                coordinate.m = Double(token)!
            } else {
                throw ParseError.UnexpectedToken(errorMessage(tokenizer, expectedToken: Token.NUMERIC_LITERAL))
            }
        }
        
        return coordinate
    }

    private class func errorMessage(tokenizer: Tokenizer, expectedToken: Token) -> String {
        return "Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column). Expected \(expectedToken) but found -> \(tokenizer.stringStream)"
    }
}
