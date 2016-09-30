/*
 *   Tokenizer.swift
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
 *   Created by Tony Stone on 5/4/16.
 */
import Swift
import Foundation

internal protocol Token {
    func match(_ string: String, matchRange: NSRange) -> NSRange
    func isNewLine() -> Bool
}

internal class Tokenizer<T : Token> {
    
    var line = 0
    var column = 0

    // FIXME: This is temporary until the the following known issue is fixed. https://github.com/apple/swift-corelibs-foundation/blob/master/Docs/Issues.md#known-issues
#if os(Linux) || os(FreeBSD)
    var matchString: String { get { return stringStream.bridge().substring(with: matchRange) } }
#else
    var matchString: String { get { return (stringStream as NSString).substring(with: matchRange) } }
#endif
    
    fileprivate var stringStream: String
    fileprivate var matchRange: NSRange
    
    init(string: String) {
        self.stringStream = string
        self.matchRange = NSMakeRange(0, string.characters.count)
        
        if self.stringStream.characters.count > 0 {
            line = 1
            column = 1
        }
    }
    
    func accept(_ token: T) -> String? {
        let range = token.match(stringStream, matchRange: matchRange)
            
        if range.location != NSNotFound {
            
            if token.isNewLine() {
                line += 1
                column = 1
            } else {
                column += range.length
            }
            // Increment the range for matching
            matchRange.location += range.length
            matchRange.length   -= range.length
            
    // FIXME: This is temporary until the the following known issue is fixed. https://github.com/apple/swift-corelibs-foundation/blob/master/Docs/Issues.md#known-issues
#if os(Linux) || os(FreeBSD)
            return stringStream.bridge().substring(with: range)
#else
            return (stringStream as NSString).substring(with: range)
#endif
        }
        return nil
    }
    
    func expect(_ token: T) -> Bool {
        return token.match(stringStream, matchRange: matchRange).location != NSNotFound
    }
}
