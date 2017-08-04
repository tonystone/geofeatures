///
///  TupleConvertible.swift
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
///  Created by Tony Stone on 2/23/2016.
///
import Swift

///
/// TupleConvertible
///
/// Specifies the contract for a type that is convertible to and from a tuple type
///
public protocol TupleConvertible {

    /// Tuple conversion type (what does the tuple look like)
    associatedtype TupleType

    /// returns the tuple representation of self.
    var tuple: TupleType { get }

    /// Instantiates an instance of Self with tuple.
    init(tuple: TupleType)

    /// Instantiates an instance of Self with tuple converting it to precision.
    init(tuple: TupleType, precision: Precision)
}
