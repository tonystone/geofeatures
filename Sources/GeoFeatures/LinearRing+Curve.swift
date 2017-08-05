///
///  LinearRing+Curve.swift
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
///  Created by Tony Stone on 2/15/2016.
///
import Swift

#if os(Linux) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

extension LinearRing: Curve {

    ///
    /// - Returns: True if this curve is closed (begin and end coordinates are equal)
    ///
    public func isClosed() -> Bool {

        return buffer.withUnsafeMutablePointers { (header, elements) -> Bool in
            if header.pointee.count < 2 { return false }

            return elements[0] == elements[header.pointee.count - 1]
        }
    }

    ///
    /// The length of this LinearType calculated using its associated CoordinateSystem.
    ///
    public func length() -> Double {

        let length: Double  = buffer.withUnsafeMutablePointers { (header, elements) -> Double in

            var length: Double = 0.0

            if header.pointee.count > 0 {

                var c1 = elements[0]

                for index in stride(from: 1, to: header.pointee.count, by: 1) {

                    let c2 = elements[index]

                    var result = pow(abs(c1.x - c2.x), 2.0) + pow(abs(c1.y - c2.y), 2.0)

                    if let c1 = c1 as? ThreeDimensional,
                       let c2 = c2 as? ThreeDimensional {

                        result += pow(abs(c1.z - c2.z), 2.0)
                    }
                    length += sqrt(result)
                    c1 = c2
                }
            }
            return length
        }
        return self.precision.convert(length)
    }
}
