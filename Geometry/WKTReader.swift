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
    case WHITE_SPACE                    = "\\s*"
    case NEW_LINE                       = "[\\n|\\r]"
    case COMMA                          = ","
    case LEFT_PAREN                     = "\\("
    case RIGHT_PAREN                    = "\\)"
    case LEFT_BRACKET                   = "\\["
    case RIGHT_BRACKET                  = "\\]"
    case LEFT_DELIMITER                 = "[\\(|\\[])"
    case RIGHT_DELIMITER                = "[\\)|\\]])"
    case SIGNED_NUMERIC_LITERAL         = "[-+]?[0-9]*\\.?[0-9]+"
    case UNSIGNED_NUMERIC_LITERAL       = "[0-9]*\\.?[0-9]+"
    case APPROXIMATE_NUMERIC_LITERAL    = "[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?"
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
            let result = stringStream.substringWithRange(range)
            
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
        
        if tokenizer.expect(.POINT) {
            
            return try self.point(tokenizer)
        }
        
        if tokenizer.expect(.LINESTRING)  {
            
            return try self.lineString(tokenizer)
        }
        
        if tokenizer.expect(.LINEARRING)  {
            
            throw ParseError.UnsupportedType(String(Token.LINEARRING))
        }
        
        if tokenizer.expect(.POLYGON)  {
            
            throw ParseError.UnsupportedType(String(Token.POLYGON))
        }
        
        if tokenizer.expect(.MULTIPOINT)  {
            
            throw ParseError.UnsupportedType(String(Token.MULTIPOINT))
        }
        
        if tokenizer.expect(.MULTILINESTRING)  {
            
            throw ParseError.UnsupportedType(String(Token.MULTILINESTRING))
        }
        
        if tokenizer.expect(.MULTIPOLYGON)  {
            
            throw ParseError.UnsupportedType(String(Token.MULTIPOLYGON))
        }
        
        if tokenizer.expect(.GEOMETRYCOLLECTION)  {
            
            throw ParseError.UnsupportedType(String(Token.GEOMETRYCOLLECTION))
        }
        
        throw ParseError.UnsupportedType(string)
    }
    
    private class func point(tokenizer: Tokenizer) throws -> Point<CoordinateType> {
        
        tokenizer.accept(.POINT)
        
        // Eat any white space
        tokenizer.accept(.WHITE_SPACE)

        if tokenizer.accept(.EMPTY) != nil {
            
            return Point<CoordinateType>(coordinate: CoordinateType())
        } else {
            
            if tokenizer.accept(.LEFT_PAREN) == nil {
                throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.LEFT_PAREN) but found -> \(tokenizer.stringStream)")
            }
            
            let coordinate = try self.coordinate(tokenizer)
            
            // Eat any white space
            tokenizer.accept(.WHITE_SPACE)
            
            if tokenizer.accept(.RIGHT_PAREN) == nil {
                throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.RIGHT_PAREN) but found -> \(tokenizer.stringStream)")
            }
    
            return Point<CoordinateType>(coordinate: coordinate)
        }
    }
    
    private class func lineString(tokenizer: Tokenizer) throws -> LineString<CoordinateType> {
        
        tokenizer.accept(.LINESTRING)
        
        // Eat any white space
        tokenizer.accept(.WHITE_SPACE)
        
        if tokenizer.accept(.EMPTY) != nil {
            
            return LineString<CoordinateType>()
        } else {
        
            if tokenizer.accept(.LEFT_PAREN) == nil {
                throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.LEFT_PAREN) but found -> \(tokenizer.stringStream)")
            }
            
            var coordinates = [CoordinateType]()

            repeat {
                coordinates.append(try self.coordinate(tokenizer))
            } while tokenizer.accept(.COMMA) != nil
            
            // Eat any white space
            tokenizer.accept(.WHITE_SPACE)
            
            if tokenizer.accept(.RIGHT_PAREN) == nil {
                throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.RIGHT_PAREN) but found -> \(tokenizer.stringStream)")
            }
            
            return LineString<CoordinateType>(elements: coordinates)
        }
    }
    
    private class func coordinate(tokenizer: Tokenizer) throws -> CoordinateType {
        
        var coordinate = CoordinateType()
        
        // Eat any white space
        tokenizer.accept(.WHITE_SPACE)
        
        if let token = tokenizer.accept(.UNSIGNED_NUMERIC_LITERAL) {
            coordinate.x = Double(token)!
        } else {
            throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.UNSIGNED_NUMERIC_LITERAL) but found -> \(tokenizer.stringStream)")
        }
        
        if tokenizer.accept(.WHITE_SPACE) == nil {
            throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.WHITE_SPACE) but found -> \(tokenizer.stringStream)")
        }
        
        if let token = tokenizer.accept(.UNSIGNED_NUMERIC_LITERAL) {
            coordinate.y = Double(token)!
        } else {
            throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.UNSIGNED_NUMERIC_LITERAL) but found -> \(tokenizer.stringStream)")
        }
        
        if var coordinate = coordinate as? ThreeDimensional {
            
            if tokenizer.accept(.WHITE_SPACE) == nil {
                throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.WHITE_SPACE) but found -> \(tokenizer.stringStream)")
            }
            
            if let token = tokenizer.accept(.UNSIGNED_NUMERIC_LITERAL) {
                coordinate.z = Double(token)!
            } else {
                throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.UNSIGNED_NUMERIC_LITERAL) but found -> \(tokenizer.stringStream)")
            }
        }
        
        if var coordinate = coordinate as? Measured {
            
            if tokenizer.accept(.WHITE_SPACE) == nil {
                throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.WHITE_SPACE) but found -> \(tokenizer.stringStream)")
            }
            
            if let token = tokenizer.accept(.UNSIGNED_NUMERIC_LITERAL) {
                coordinate.m = Double(token)!
            } else {
                throw ParseError.UnexpectedToken("Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column).  Expected \(Token.UNSIGNED_NUMERIC_LITERAL) but found -> \(tokenizer.stringStream)")
            }
        }
        
        return coordinate
    }

}
