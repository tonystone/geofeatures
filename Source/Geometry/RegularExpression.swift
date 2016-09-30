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
    
    typealias RegularExpressionOptions = Foundation.NSRegularExpression.Options
    typealias MatchingOptions = Foundation.NSRegularExpression.MatchingOptions
    
    var regex: Foundation.NSRegularExpression? = nil
    
    init(_ pattern: String, options: RegularExpressionOptions = []) {
        do {
            regex = try Foundation.NSRegularExpression(pattern: pattern, options: options)
        } catch {}
    }
    
    /**
        Apply self to the in (String) returning the range of the first match or nil if not matched.
     */
    func rangeOfFirstMatch(in string: String, options: MatchingOptions = [], matchRange: NSRange) -> NSRange {
        
        if let regex = regex {
            let range = regex.rangeOfFirstMatch(in: string, options: options, range: matchRange)

            return range
        }
        return NSMakeRange(0, NSNotFound)
    }
}
