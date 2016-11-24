///
///  Tokenizer.swift
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
///  Created by Tony Stone on 5/4/2016.
///
import Swift
import Foundation

internal protocol Token {
    func match(_ string: String, matchRange: Range<String.Index>) -> Range<String.Index>?
    func isNewLine() -> Bool
}

internal class Tokenizer<T: Token> {

    var line = 0
    var column = 0

    fileprivate var stringStream: String
    fileprivate var matchRange: Range<String.Index>

    init(string: String) {
        self.stringStream = string
        self.matchRange = stringStream.startIndex..<stringStream.endIndex

        if !self.stringStream.isEmpty {
            line = 1
            column = 1
        }
    }

    func accept(_ token: T) -> String? {
        if let range = token.match(stringStream, matchRange: matchRange) {

            let match = stringStream.substring(with: range)

            // Increment the range for matching
            matchRange = range.upperBound..<matchRange.upperBound

            if token.isNewLine() {
                line += 1
                column = 1
            } else {
                // Note: we're counting visual characters not the number of Code Units it takes to hold a character which is why we use the character view.
                column += match.characters.count
            }
            return match
        }
        return nil
    }

    func expect(_ token: T) -> Bool {
        return token.match(stringStream, matchRange: matchRange) != nil
    }

    var matchString: String {
        get {
            return stringStream.substring(with: matchRange)
        }
    }
}
