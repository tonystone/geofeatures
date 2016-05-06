/*
 *   RegularExpression.swift
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
import Foundation

/**
    RegularExpression
 */
internal class RegularExpression {
    
    typealias RegularExpressionOptions = NSRegularExpressionOptions
    typealias MatchingOptions = NSMatchingOptions
    
    var regex: NSRegularExpression? = nil
    
    init(_ pattern: String, options: RegularExpressionOptions = []) {
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {}
    }
    
    /**
        Apply self to the in (String) returning the range of the first match or nil if not matched.
     */
    func rangeOfFirstMatch(in string: String, options: MatchingOptions = []) -> Range<String.Index>? {
        
        if let regex = regex {
            let range = regex.rangeOfFirstMatch(in: string, options: options, range: NSRange(location: 0, length: string.characters.count))
            
            return range.toRange(for: string)
        }
        return nil
    }
}

/**
    Private helper extension to NSRange
 */
private extension NSRange {
    
    func toRange (for string: String) -> Range<String.Index>? {
        
        guard self.location != NSNotFound else {
            return nil
        }

        let start = string.characters.index(string.characters.startIndex, offsetBy: self.location)
        let end   = string.characters.index(string.characters.startIndex, offsetBy: self.location + self.length)
    
        return start..<end
    }
}
