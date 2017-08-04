///
///  GeoJSONReader.swift
///
///  Copyright 2016 Tony Stone
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
///  Created by Tony Stone on 2/10/16.
///
import Swift
import Foundation

public enum GeoJSONReaderError: Error {
    case invalidJSON(String)
    case invalidEncoding(String)
    case invalidNumberOfCoordinates(String)
    case unsupportedType(String)
    case missingAttribute(String)
}

///
/// GeoJSON reader for GeoFeatures based on the Internet Engineering Task Force (IETF) proposed standard "The GeoJSON Format"
///
/// - Parameters:
///     - CoordinateType: The coordinate type to use for all generated Geometry types.
///
/// For more information see [Internet Engineering Task Force (IETF) - The GeoJSON Format](https://tools.ietf.org/html/rfc7946#section-4)
///
public class GeoJSONReader<CoordinateType: Coordinate & CopyConstructable & _ArrayConstructable> {

    fileprivate let expectedStringEncoding = String.Encoding.utf8

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
    /// Read a GeoJSON string into Geometry objects.
    ///
    /// - Parameters:
    ///     - string: The GeoJSON string to read
    ///
    /// - Returns: A Geometry object representing the GeoJSON
    ///
    public func read(string: String) throws -> Geometry {
        return try self.read(data: Data(bytes: Array(string.utf8)))
    }

    ///
    /// Read a json Data object into Geometry objects.
    ///
    /// - Parameters:
    ///     - data: The GeoJSON Data object to read
    ///
    /// - Returns: A Geometry object representing the GeoJSON
    ///
    public func read(data: Data) throws -> Geometry {

        var parsedJSON: Any = ""

        do {
            parsedJSON = try JSONSerialization.jsonObject(with: data)

        } catch let error as NSError {
            throw GeoJSONReaderError.invalidJSON(error.localizedDescription)
        }

        guard let jsonObject = parsedJSON as? [String : Any] else {
            throw GeoJSONReaderError.invalidJSON("Root JSON must be an object type.")
        }

        return try read(jsonObject: jsonObject)
    }

    ///
    /// Read a (Geo)JSON Object into Geometry objects.
    ///
    /// - Parameters:
    ///     - jsonObject: The GeoJSON object to read
    ///
    /// - Returns: A Geometry object representing the GeoJSON
    ///
    public func read(jsonObject: [String : Any]) throws -> Geometry {

        guard let type = jsonObject["type"] as? String else {
            throw GeoJSONReaderError.missingAttribute("Missing required attribute \"type\".")
        }

        switch type {

        case "Point":
            return try point(jsonObject: jsonObject)

        case "LineString":
            return try lineString(jsonObject: jsonObject)

        case "Polygon":
            return try polygon(jsonObject: jsonObject)

        case "MultiPoint":
            return try multiPoint(jsonObject: jsonObject)

        case "MultiLineString":
            return try multiLineString(jsonObject: jsonObject)

        case "MultiPolygon":
            return try multiPolygon(jsonObject: jsonObject)

        case "GeometryCollection":
            return try geometryCollection(jsonObject: jsonObject)

        default:
            throw GeoJSONReaderError.unsupportedType("Unsupported type \"\(type)\".")
        }
    }

    /// Parse a Point type
    private func point(jsonObject: [String : Any]) throws -> Point<CoordinateType> {

        let coordinates = try Coordinates<[Double]>.coordinates(json: jsonObject)

        return try self.point(coordinates: coordinates)
    }

    /// Parse coordinates into a Point
    private func point(coordinates: [Double]) throws -> Point<CoordinateType> {

        return Point<CoordinateType>(coordinate: try self.coordinate(array: coordinates), precision: self.precision, coordinateSystem: self.cs)
    }

    /// Parse a LineString type
    private func lineString(jsonObject: [String : Any]) throws -> LineString<CoordinateType> {

        let coordinates = try Coordinates<[[Double]]>.coordinates(json: jsonObject)

        return LineString<CoordinateType>(elements: try self.coordinates(jsonArray: coordinates), precision: self.precision, coordinateSystem: self.cs)
    }

    /// Parse coordinates into a LineString
    private func lineString(coordinates: [[Double]]) throws -> LineString<CoordinateType> {

        var elements: [CoordinateType] = []

        for elementCoordinates in coordinates {
            elements.append(try self.coordinate(array: elementCoordinates))
        }

        return LineString<CoordinateType>(elements: try self.coordinates(jsonArray: coordinates), precision: self.precision, coordinateSystem: self.cs)
    }

    /// Parse a Polygon type
    private func polygon(jsonObject: [String : Any]) throws -> Polygon<CoordinateType> {

        let coordinates = try Coordinates<[[[Double]]]>.coordinates(json: jsonObject)

        return try self.polygon(coordinates: coordinates)
    }

    /// Parse coordinates into a Polygon
    private func polygon(coordinates: [[[Double]]]) throws -> Polygon<CoordinateType> {

        var outerRing:  LinearRing<CoordinateType> = LinearRing<CoordinateType>(precision: self.precision, coordinateSystem: self.cs)
        var innerRings: [LinearRing<CoordinateType>] = []

        if coordinates.count > 0 {
            outerRing.append(contentsOf: try self.coordinates(jsonArray: coordinates[0]))
        }

        /// Get the inner rings
        for i in stride(from: 1, to: coordinates.count, by: 1) {
            innerRings.append(LinearRing<CoordinateType>(elements: try self.coordinates(jsonArray: coordinates[i]), precision: self.precision, coordinateSystem: self.cs))
        }
        return Polygon<CoordinateType>(outerRing: outerRing, innerRings: innerRings, precision: self.precision, coordinateSystem: self.cs)
    }

    /// Parse a MultiPoint type
    private func multiPoint(jsonObject: [String : Any]) throws -> MultiPoint<CoordinateType> {

        let coordinates = try Coordinates<[[Double]]>.coordinates(json: jsonObject)

        return try self.multiPoint(coordinates: coordinates)
    }

    /// Parse coordinates into a MultiPoint
    private func multiPoint(coordinates: [[Double]]) throws -> MultiPoint<CoordinateType> {

        var elements: [Point<CoordinateType>] = []

        for elementCoordinates in coordinates {
            elements.append(try self.point(coordinates: elementCoordinates))
        }

        return MultiPoint<CoordinateType>(elements: elements, precision: self.precision, coordinateSystem: self.cs)
    }

    /// Parse a MultiLineString type
    private func multiLineString(jsonObject: [String : Any]) throws -> MultiLineString<CoordinateType> {

        let coordinates = try Coordinates<[ [[Double]] ]>.coordinates(json: jsonObject)

        return try self.multiLineString(coordinates: coordinates)
    }

    /// Parse coordinates into a MultiPoint
    private func multiLineString(coordinates: [ [[Double]] ]) throws -> MultiLineString<CoordinateType> {

        var elements: [LineString<CoordinateType>] = []

        for elementCoordinates in coordinates {
            elements.append(try self.lineString(coordinates: elementCoordinates))
        }

        return MultiLineString<CoordinateType>(elements: elements, precision: self.precision, coordinateSystem: self.cs)
    }

    /// Parse a MultiPolygon type
    private func multiPolygon(jsonObject: [String : Any]) throws -> MultiPolygon<CoordinateType> {

        let coordinates = try Coordinates<[ [[[Double]]] ]>.coordinates(json: jsonObject)

        return try self.multiPolygon(coordinates: coordinates)
    }

    /// Parse coordinates into a MultiPolygon
    private func multiPolygon(coordinates: [ [[[Double]]] ]) throws -> MultiPolygon<CoordinateType> {

        var elements: [Polygon<CoordinateType>] = []

        for elementCoordinates in coordinates {
            elements.append(try self.polygon(coordinates: elementCoordinates))
        }

        return MultiPolygon<CoordinateType>(elements: elements, precision: self.precision, coordinateSystem: self.cs)
    }

    /// Parse a GeometryCollection type
    private func geometryCollection(jsonObject: [String : Any]) throws -> GeometryCollection {
        var elements: [Geometry] = []

        guard let geometriesObject = jsonObject["geometries"] else {
            throw GeoJSONReaderError.missingAttribute("Missing required attribute \"geometries\".")
        }

        guard let geometries = geometriesObject as? [[String : Any]] else {
            throw GeoJSONReaderError.invalidJSON("Invalid structure for \"geometries\" attribute.")
        }

        for object in geometries {
            elements.append(try self.read(jsonObject: object))
        }
        return GeometryCollection(elements: elements, precision: self.precision, coordinateSystem: self.cs)
    }

    private func coordinates(jsonArray: [[Double]]) throws -> [CoordinateType] {
        var coordinates: [CoordinateType] = []

        for coordinate in jsonArray {
            coordinates.append(try self.coordinate(array: coordinate))
        }
        return coordinates
    }

    private func coordinate(array: [Double]) throws -> CoordinateType {

        ///
        /// Since `CoordinateType.init(array:)` does not throw, we need to determine if the proper
        /// number of coordinates were passed to construct it.
        ///
        guard 2 + (CoordinateType.self is Measured.Type ? 1 : 0) + (CoordinateType.self is ThreeDimensional.Type ? 1 : 0) == array.count else {
            throw GeoJSONReaderError.invalidNumberOfCoordinates("Invalid number of coordinates (\(array.count)) supplied for type \(String(reflecting: CoordinateType.self)).")
        }
        return CoordinateType(array: array)
    }
}

fileprivate class Coordinates<T> {

    class func coordinates(json: [String: Any]) throws -> T {

        guard let coordinatesObject = json["coordinates"] else {
            throw GeoJSONReaderError.missingAttribute("Missing required attribute \"coordinates\".")
        }

        guard let coordinates = coordinatesObject as? T else {
            throw GeoJSONReaderError.invalidJSON("Invalid structure for \"coordinates\" attribute.")
        }
        return coordinates
    }
}
