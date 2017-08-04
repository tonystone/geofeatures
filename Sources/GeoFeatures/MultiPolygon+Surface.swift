///
///  MultiPolygon+Surface.swift
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
///  Created by Tony Stone on 3/29/2016.
///
import Swift

extension MultiPolygon: Surface {

    public func area() -> Double {

        return buffer.withUnsafeMutablePointers { (header, elements) -> Double in

            var area: Double = 0.0

            if header.pointee.count > 0 {

                for index in 0..<header.pointee.count {
                    area += elements[index].area()
                }
            }
            return self.precision.convert(area)
        }
    }
}
