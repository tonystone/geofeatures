///
///  FloatingPrecision.swift
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
///  Created by Tony Stone on 2/11/2016.
///
import Swift

public struct FloatingPrecision: Precision, Equatable, Hashable {

    public var hashValue: Int {
        return 31.hashValue
    }

    public init() {}

    public func convert(_ value: Double) -> Double {
        return value
    }
}
extension FloatingPrecision: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        return "\(type(of: self))"
    }

    public var debugDescription: String {
        return self.description
    }
}
