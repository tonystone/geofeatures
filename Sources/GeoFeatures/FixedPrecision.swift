///
///  FixedPrecision.swift
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

#if os(Linux) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

public struct FixedPrecision: Precision, Equatable, Hashable  {

    public let scale: Double

    public var hashValue: Int {
        return 31.hashValue + scale.hashValue
    }

    public init(scale: Double) {
        self.scale = abs(scale)
    }

    public func convert(_ value: Double) -> Double {
        return round(value * scale) / scale
    }
}
extension FixedPrecision: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        return "\(type(of: self))(scale: \(self.scale))"
    }

    public var debugDescription: String {
        return self.description
    }
}
