//: [Previous](@previous)

import Foundation


let input = "init<C: Swift.Collection>(elements: C, precision: Precision, coordinateSystem: CoordinateSystem) -> Bool where C.Iterator.Element == Element"

let match = input.range(of: "\\)[ \\t]*(?:->[ \\t]*[a-zA-Z0-9]*[ \\t]*)?[^\\r\\n][ \\t]*where[ \\t]", options: .regularExpression, range: input.startIndex..<input.endIndex, locale: Locale(identifier: "en_US"))

if let match = match {
    print(input[match])
}

