/*
 *   LineString+LinearType.swift
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
 *   Created by Tony Stone on 2/15/16.
 */
import Swift

extension LineString : LinearType {
    
    /**
     The length of this LinearType calaculated using its associated CoordinateReferenceSystem.
     */
    @warn_unused_result
    public func length() -> Double {

        var length = 0.0
        
        if self.coordinateReferenceSystem is Cartesian {
            var generator = self.generate()
            
            if let c1 = generator.next() {
                while let  c2 = generator.next() {
                    length += sqrt(pow(abs(c1.x - c2.x), 2) + pow(abs(c1.y - c2.y), 2) + (self.dimension == 3 ? pow(abs(c1.z - c2.z), 2) : 0))
                }
            }
        }
        return self.precision.convert(length)
    }
}
