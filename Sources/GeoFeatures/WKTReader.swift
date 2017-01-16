///
///  WKTReader.swift
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
///  Created by Tony Stone on 2/10/2016.
///
import Swift
import Foundation

#if os(Linux) || os(FreeBSD)
#else
    fileprivate typealias RegularExpression = NSRegularExpression
#endif

public enum WKTReaderError: Error  {
    case invalidNumberOfCoordinates(String)
    case invalidData(String)
    case unsupportedType(String)
    case unexpectedToken(String)
    case missingElement(String)
}

private class WKT: Token, CustomStringConvertible {

    /// Note: we're making an exception for the lint for these variables names since they make the file more readable in general.
    // swiftlint:disable variable_name
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
    // swiftlint:enable variable_name

    init(_ description: String, pattern value: StringLiteralType) {
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

///
/// Well Known Text (WKT) parser for GeoFeatures based on the OGC WKT specification
///
/// - Parameters:
///     - CoordinateType: The coordinate type to use for all generated Geometry types.
///
public class WKTReader<CoordinateType: Coordinate & CopyConstructable & _ArrayConstructable> {

    fileprivate let cs: CoordinateSystem
    fileprivate let precision: Precision

    ///
    /// Initialize this reader
    ///
    /// - Parameters:
    ///     - precision: The `Precision` model that should used for all coordinates.
    ///     - coordinateSystem: The 'CoordinateSystem` the result Geometries should use in calculations on their coordinates.
    ///
    /// - SeeAlso: `Precision`
    /// - SeeAlso: `CoordinateSystem`
    ///
    public init(precision: Precision = defaultPrecision, coordinateSystem: CoordinateSystem = defaultCoordinateSystem) {
        self.cs = coordinateSystem
        self.precision = precision
    }

    ///
    /// Parse a WKT String into Geometry objects.
    ///
    /// - Parameters:
    ///     - string: The WKT string to parse
    ///
    /// - Returns: A Geometry object representing the WKT
    ///
    public func read(string: String) throws -> Geometry {

        let tokenizer = Tokenizer<WKT>(string: string)

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

        /// BNF: <point tagged text> ::= point <point text>
        if tokenizer.accept(.POINT) != nil {
            return try self.pointTaggedText(tokenizer, require: (z: nil, m: nil))
        }

        /// BNF: <linestring tagged text> ::= linestring <linestring text>
        if tokenizer.accept(.LINESTRING) != nil {
            return try self.lineStringTaggedText(tokenizer, require: (z: nil, m: nil))
        }

        /// Currently unsupported by OGC
        if tokenizer.accept(.LINEARRING) != nil {
            return try self.linearRingTaggedText(tokenizer, require: (z: nil, m: nil))
        }

        /// BNF: <polygon tagged text> ::= polygon <polygon text>
        if tokenizer.accept(.POLYGON) != nil {
            return try self.polygonTaggedText(tokenizer, require: (z: nil, m: nil))
        }

        /// BNF: <multipoint tagged text> ::= multipoint <multipoint text>
        if tokenizer.accept(.MULTIPOINT) != nil {
            return try self.multiPointTaggedText(tokenizer, require: (z: nil, m: nil))
        }

        /// BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
        if tokenizer.accept(.MULTILINESTRING) != nil {
            return try self.multiLineStringTaggedText(tokenizer, require: (z: nil, m: nil))
        }

        /// BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
        if tokenizer.accept(.MULTIPOLYGON) != nil {
            return try self.multiPolygonTaggedText(tokenizer, require: (z: nil, m: nil))
        }

        /// BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
        if tokenizer.accept(.GEOMETRYCOLLECTION) != nil {
            return try self.geometryCollectionTaggedText(tokenizer, require: (z: nil, m: nil))
        }
        throw WKTReaderError.unsupportedType("Unsupported type -> '\(string)'")
    }

    ///
    /// Parse the WKT Data object into Geometry objects.
    ///
    /// - Parameters:
    ///     - data: The Data object to parse
    ///     - encoding: The encoding that should be used to read the data.
    ///
    /// - Returns: A Geometry object representing the WKT
    ///
    public func read(data: Data, encoding: String.Encoding = .utf8) throws -> Geometry {

        guard let string = String(data: data, encoding: encoding) else {
            throw WKTReaderError.invalidData("The Data object can not be converted using the given encoding '\(encoding)'.")
        }
        return try self.read(string: string)
    }

    /// BNF: <point tagged text> ::= point <point text>
    fileprivate func pointTaggedText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> Point<CoordinateType> {

        return try pointText(tokenizer, require: try dimensionText(tokenizer, require: require))
    }

    /// BNF: <point text> ::= <empty set> | <left paren> <point> <right paren>
    fileprivate func pointText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> Point<CoordinateType> {

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        let coordinate = try self.coordinate(tokenizer, require: require)

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return Point<CoordinateType>(coordinate: coordinate, precision: precision, coordinateSystem: cs)
    }

    /// BNF: <linestring tagged text> ::= linestring <linestring text>
    fileprivate func lineStringTaggedText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> LineString<CoordinateType> {

        return try lineStringText(tokenizer, require: try dimensionText(tokenizer, require: require))
    }

    /// BNF: <linestring text> ::= <empty set> | <left paren> <point> {<comma> <point>}* <right paren>
    fileprivate func lineStringText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> LineString<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return LineString<CoordinateType>(precision: precision, coordinateSystem: cs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        var coordinates = [CoordinateType]()

        var done = false

        repeat {
            coordinates.append(try self.coordinate(tokenizer, require: require))

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return LineString<CoordinateType>(elements: coordinates, precision: precision, coordinateSystem: cs)
    }

    /// BNF: None defined by OGC
    fileprivate func linearRingTaggedText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> LinearRing<CoordinateType> {

        return try linearRingText(tokenizer, require: try dimensionText(tokenizer, require: require))
    }

    /// BNF: None defined by OGC
    fileprivate func linearRingText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> LinearRing<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return LinearRing<CoordinateType>(precision: precision, coordinateSystem: cs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        var coordinates = [CoordinateType]()

        var done = false

        repeat {
            coordinates.append(try self.coordinate(tokenizer, require: require))

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return LinearRing<CoordinateType>(elements: coordinates, precision: precision, coordinateSystem: cs)
    }

    /// BNF: <polygon tagged text> ::= polygon <polygon text>
    fileprivate func polygonTaggedText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> Polygon<CoordinateType> {

        return try polygonText(tokenizer, require: try dimensionText(tokenizer, require: require))
    }

    /// BNF: <polygon text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    fileprivate func polygonText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> Polygon<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return Polygon<CoordinateType>(precision: precision, coordinateSystem: cs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        let outerRing = try self.linearRingText(tokenizer, require: require)

        if tokenizer.accept(.RIGHT_PAREN) != nil {
            return Polygon<CoordinateType>(outerRing: outerRing, innerRings: [])
        }

        if tokenizer.accept(.COMMA) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .COMMA))
        }

        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }

        var innerRings = [LinearRing<CoordinateType>]()

        var done = false

        repeat {
            innerRings.append(try self.linearRingText(tokenizer, require: require))

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return Polygon<CoordinateType>(outerRing: outerRing, innerRings: innerRings)
    }

    /// BNF: <multipoint tagged text> ::= multipoint <multipoint text>
    fileprivate func multiPointTaggedText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> MultiPoint<CoordinateType> {

        return try multiPointText(tokenizer, require: try dimensionText(tokenizer, require: require))
    }

    /// BNF: <multipoint text> ::= <empty set> | <left paren> <point text> {<comma> <point text>}* <right paren>
    fileprivate func multiPointText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> MultiPoint<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return MultiPoint<CoordinateType>(precision: precision, coordinateSystem: cs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        var elements = [Point<CoordinateType>]()

        var done = false

        repeat {
            elements.append(try self.pointText(tokenizer, require: require))

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return MultiPoint<CoordinateType>(elements: elements, precision: precision, coordinateSystem: cs)
    }

    /// BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
    fileprivate func multiLineStringTaggedText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> MultiLineString<CoordinateType> {

        return try multiLineStringText(tokenizer, require: try dimensionText(tokenizer, require: require))
    }

    /// BNF: <multilinestring text> ::= <empty set> | <left paren> <linestring text> {<comma> <linestring text>}* <right paren>
    fileprivate func multiLineStringText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> MultiLineString<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return MultiLineString<CoordinateType>(precision: precision, coordinateSystem: cs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        var elements = [LineString<CoordinateType>]()
        var done     = false

        repeat {
            elements.append(try self.lineStringText(tokenizer, require: require))

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return MultiLineString<CoordinateType>(elements: elements, precision: precision, coordinateSystem: cs)
    }

    /// BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
    fileprivate func multiPolygonTaggedText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> MultiPolygon<CoordinateType> {

        return try multiPolygonText(tokenizer, require: try dimensionText(tokenizer, require: require))
    }

    /// BNF: <multipolygon text> ::= <empty set> | <left paren> <polygon text> {<comma> <polygon text>}* <right paren>
    fileprivate func multiPolygonText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> MultiPolygon<CoordinateType> {

        if tokenizer.accept(.EMPTY) != nil {
            return MultiPolygon<CoordinateType>(precision: precision, coordinateSystem: cs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        var elements = [Polygon<CoordinateType>]()
        var done = false

        repeat {

            elements.append(try self.polygonText(tokenizer, require: require))

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }

        return MultiPolygon<CoordinateType>(elements: elements)
    }

    /// BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
    fileprivate func geometryCollectionTaggedText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> GeometryCollection {

        return try geometryCollectionText(tokenizer, require: try dimensionText(tokenizer, require: require))
    }

    /// BNF: <geometrycollection text> ::= <empty set> | <left paren> <geometry tagged text> {<comma> <geometry tagged text>}* <right paren>
    fileprivate func geometryCollectionText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> GeometryCollection {

        if tokenizer.accept(.EMPTY) != nil {
            return GeometryCollection(precision: precision, coordinateSystem: cs)
        }

        if tokenizer.accept(.LEFT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .LEFT_PAREN))
        }

        var elements = [Geometry]()
        var done     = false

        repeat {
            /// BNF: <point tagged text> ::= point <point text>
            if tokenizer.accept(.POINT) != nil {
                elements.append(try self.pointTaggedText(tokenizer, require: (z: require.z, m: require.m)))

            /// BNF: <linestring tagged text> ::= linestring <linestring text>
            } else if tokenizer.accept(.LINESTRING) != nil {
                elements.append(try self.lineStringTaggedText(tokenizer, require: (z: require.z, m: require.m)))

            /// Currently unsupported by OGC
            } else if tokenizer.accept(.LINEARRING) != nil {
                elements.append(try self.linearRingTaggedText(tokenizer, require: (z: require.z, m: require.m)))

            /// BNF: <polygon tagged text> ::= polygon <polygon text>
            } else if tokenizer.accept(.POLYGON) != nil {
                elements.append(try self.polygonTaggedText(tokenizer, require: (z: require.z, m: require.m)))

            /// BNF: <multipoint tagged text> ::= multipoint <multipoint text>
            } else if tokenizer.accept(.MULTIPOINT) != nil {
                elements.append(try self.multiPointTaggedText(tokenizer, require: (z: require.z, m: require.m)))

            /// BNF: <multilinestring tagged text> ::= multilinestring <multilinestring text>
            } else if tokenizer.accept(.MULTILINESTRING) != nil {
                elements.append(try self.multiLineStringTaggedText(tokenizer, require: (z: require.z, m: require.m)))

            /// BNF: <multipolygon tagged text> ::= multipolygon <multipolygon text>
            } else if tokenizer.accept(.MULTIPOLYGON) != nil {
                elements.append(try self.multiPolygonTaggedText(tokenizer, require: (z: require.z, m: require.m)))

            /// BNF: <geometrycollection tagged text> ::= geometrycollection <geometrycollection text>
            } else if tokenizer.accept(.GEOMETRYCOLLECTION) != nil {
                elements.append(try self.geometryCollectionTaggedText(tokenizer, require: (z: require.z, m: require.m)))
            } else {
                throw WKTReaderError.missingElement("At least one Geometry is required unless you specify EMPTY for the GoemetryCollection")
            }

            if tokenizer.accept(.COMMA) != nil {
                if tokenizer.accept(.SINGLE_SPACE) == nil {
                    throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
                }
            } else {
                done = true
            }
        } while !done

        if tokenizer.accept(.RIGHT_PAREN) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .RIGHT_PAREN))
        }
        return GeometryCollection(elements: elements, precision: precision, coordinateSystem: cs)
    }

    /// BNF: <point> ::= <x> <y>
    /// BNF: <point z> ::= <x> <y> <z>
    /// BNF: <point m> ::= <x> <y> <m>
    /// BNF: <point zm> ::= <x> <y> <z> <m>
    fileprivate func coordinate(_ tokenizer: Tokenizer<WKT>, require: (z: Bool, m: Bool)) throws -> CoordinateType {

        var coordinates = [Double]()

        if let token = tokenizer.accept(.NUMERIC_LITERAL), let value = Double(token) {
            coordinates.append(value)
        } else {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
        }

        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }

        if let token = tokenizer.accept(.NUMERIC_LITERAL), let value = Double(token) {
            coordinates.append(value)
        } else {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
        }

        if require.z {

            if tokenizer.accept(.SINGLE_SPACE) == nil {
                throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
            }

            if let token = tokenizer.accept(.NUMERIC_LITERAL), let value = Double(token) {
                coordinates.append(value)
            } else {
                throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
            }
        }

        if require.m {

            if tokenizer.accept(.SINGLE_SPACE) == nil {
                throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
            }

            if let token = tokenizer.accept(.NUMERIC_LITERAL), let value = Double(token) {
                coordinates.append(value)
            } else {
                throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .NUMERIC_LITERAL))
            }
        }

        ///
        /// Since `CoordinateType.init(array:)` does not throw, we need to determine if the proper
        /// number of coordinates were passed to construct it.
        ///
        guard 2 + (CoordinateType.self is Measured.Type ? 1 : 0) + (CoordinateType.self is ThreeDimensional.Type ? 1 : 0) == coordinates.count else {
            throw WKTReaderError.invalidNumberOfCoordinates("Invalid number of coordinates (\(coordinates.count)) supplied for type \(String(reflecting: CoordinateType.self)).")
        }
        return CoordinateType(array: coordinates)
    }

    fileprivate func dimensionText(_ tokenizer: Tokenizer<WKT>, require: (z: Bool?, m: Bool?)) throws -> (z: Bool, m: Bool) {

        var result = (z: false, m: false)

        if tokenizer.accept(.SINGLE_SPACE) == nil {
            throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
        }

        if let requireZ = require.z, requireZ  == true { // Z is required and must be present

            result.z = requireZ

            if tokenizer.accept(.THREEDIMENSIONAL) == nil {
                throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .THREEDIMENSIONAL))
            }
        } else {
            result.z = tokenizer.accept(.THREEDIMENSIONAL) != nil
        }

        if let requireM = require.m, requireM == true { // M is required and must be present

            result.m = requireM

            if tokenizer.accept(.MEASURED) == nil {
                throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .MEASURED))
            }
        } else {
            result.m = tokenizer.accept(.MEASURED) != nil
        }

        /// If either was present, a single space after it is required.
        if result.z || result.m {
            if tokenizer.accept(.SINGLE_SPACE) == nil {
                throw WKTReaderError.unexpectedToken(errorMessage(tokenizer, expectedToken: .SINGLE_SPACE))
            }
        }
        return result
    }

    fileprivate func errorMessage(_ tokenizer: Tokenizer<WKT>, expectedToken: WKT) -> String {
        return "Unexpected token at line: \(tokenizer.line) column: \(tokenizer.column). Expected '\(expectedToken)' but found -> '\(tokenizer.matchString)'"
    }
}
