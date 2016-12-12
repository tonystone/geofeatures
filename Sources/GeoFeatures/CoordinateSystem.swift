///
///  CoordinateSystem.swift
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
///  Created by Tony Stone on 2/5/2016.
///
import Swift

///
/// Coordinate System Types
///
/// These are used by the algorithms when they are applied to the types
///
public protocol CoordinateSystem {}

public struct Cartesian: CoordinateSystem {

    public init() {}
}

extension Cartesian: Equatable, Hashable {
    public var hashValue: Int {
        return String(reflecting: self).hashValue
    }
}

@available(*, unavailable, message: "currently not supported")
public struct Ellipsoidal: CoordinateSystem {}

@available(*, unavailable, message: "currently not supported")
public struct Spherical: CoordinateSystem {}

@available(*, unavailable, message: "currently not supported")
public struct Vertical: CoordinateSystem {}

@available(*, unavailable, message: "currently not supported")
public struct Polar: CoordinateSystem {}

public func == <T1: CoordinateSystem & Hashable, T2: CoordinateSystem & Hashable>(lhs: T1, rhs: T2) -> Bool {
    if type(of: lhs) == type(of: rhs) {
        return lhs.hashValue == rhs.hashValue
    }
    return false
}
