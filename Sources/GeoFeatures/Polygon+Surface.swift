///
///  Polygon+Surface.swift
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
import Foundation

extension Polygon: Surface {

    ///
    /// Calculates the area of this `Polygon`
    ///
    /// - returns: The area of this `Polygon`.
    ///
    /// - requires: The "outerRing" be oriented clockwise
    /// - requires: The "innerRings" be oriented counter clockwise
    /// - requires: isSimple == true
    /// - requires: isClosed == true for "outerRing" and all "innerRings"
    ///
    public func area() -> Double {

        return buffer.withUnsafeMutablePointers { (header, elements) -> Double in

            var area: Double = 0.0

            for i in 0..<header.pointee.count {
                area += elements[i].area()
            }
            return self.precision.convert(area)
        }
    }
}
