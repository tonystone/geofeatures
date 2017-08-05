///
///  TokenizerTests.swift
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
///  Created by Tony Stone on 11/9/2016.
///
import XCTest
@testable import GeoFeatures

#if os(Linux) || os(FreeBSD)
#else
    fileprivate typealias RegularExpression = NSRegularExpression
#endif

private class TestToken: Token, CustomStringConvertible {

    /// Note: we're making an exception for the lint for these variables names since they make the file more readable in general.
    // swiftlint:disable variable_name
    static let WHITE_SPACE                     = TestToken("white space",         pattern:  "^[ \\t]+")
    static let SINGLE_SPACE                    = TestToken("single space",        pattern:  "^ (?=[^ ])")
    static let NEW_LINE                        = TestToken("\n or \r",            pattern:  "^[\\n|\\r]")
    static let COMMA                           = TestToken(",",                   pattern:  "^,")
    static let LEFT_PAREN                      = TestToken("(",                   pattern:  "^\\(")
    static let RIGHT_PAREN                     = TestToken(")",                   pattern:  "^\\)")
    static let GLOBE                           = TestToken("🌍",                  pattern:  "^🌍")
    static let FLAG                            = TestToken("🇵🇷",                  pattern:  "^🇵🇷")
    static let E_PLUS_ACCENT                   = TestToken("é",                   pattern:  "^e\u{0301}")
    static let E_WITH_ACCENT                   = TestToken("é",                   pattern:  "^é")
    // swiftlint:enable variable_name

    init(_ description: String, pattern value: StringLiteralType) {
        self.description = description
        self.pattern     = value
    }

    func match(_ string: String, matchRange: Range<String.Index>) -> Range<String.Index>? {
        return string.range(of: self.pattern, options: [.regularExpression, .caseInsensitive], range: matchRange, locale: Locale(identifier: "en_US"))
    }

    func isNewLine() -> Bool {
        return self.description == TestToken.NEW_LINE.description
    }

    var description: String
    var pattern: String
}

class TokenizerTests: XCTestCase {

    func testExpectSingleWhiteSpaceTrue() {
        let tokenizer = Tokenizer<TestToken>(string: " (")

        XCTAssertTrue(tokenizer.expect(.SINGLE_SPACE))
    }

    func testExpectSingleWhiteSpaceFalse() {
        let tokenizer = Tokenizer<TestToken>(string: "  ")

        XCTAssertFalse(tokenizer.expect(.SINGLE_SPACE))
    }

    func testMatchSingleWhiteSpaceTrue() {
        let tokenizer = Tokenizer<TestToken>(string: " (")

        XCTAssertNotNil(tokenizer.accept(.SINGLE_SPACE))
    }

    func testMatchSingleWhiteSpaceFalse() {
        let tokenizer = Tokenizer<TestToken>(string: "  ")

        XCTAssertNil(tokenizer.accept(.SINGLE_SPACE))
    }

    func testMatchNewLineTrue() {
        let tokenizer = Tokenizer<TestToken>(string: "\n")

        XCTAssertNotNil(tokenizer.accept(.NEW_LINE))
    }

    func testMatchNewLineFalse() {
        let tokenizer = Tokenizer<TestToken>(string: "  ")

        XCTAssertNil(tokenizer.accept(.NEW_LINE))
    }

    func testMatchUnicodeGlobeTrue() {
        let tokenizer = Tokenizer<TestToken>(string: "🌍")

        XCTAssertNotNil(tokenizer.accept(.GLOBE))
    }

    func testMatchUnicodeGlobeFalse() {
        let tokenizer = Tokenizer<TestToken>(string: "  ")

        XCTAssertNil(tokenizer.accept(.GLOBE))
    }

    func testMatchUnicodeFlagTrue() {
        let tokenizer = Tokenizer<TestToken>(string: "🇵🇷")

        XCTAssertNotNil(tokenizer.accept(.FLAG))
    }

    func testMatchUnicodeFlagFalse() {
        let tokenizer = Tokenizer<TestToken>(string: "  ")

        XCTAssertNil(tokenizer.accept(.FLAG))
    }

    func testMatchUnicodeEPlusAccent() {
        let tokenizer = Tokenizer<TestToken>(string: "e\u{0301}")

        XCTAssertNotNil(tokenizer.accept(.E_PLUS_ACCENT))
    }

    func testMatchUnicodeEPlusAccentFalse() {
        let tokenizer = Tokenizer<TestToken>(string: "  ")

        XCTAssertNil(tokenizer.accept(.E_PLUS_ACCENT))
    }

    func testMatchUnicodeEWithAccent() {
        let tokenizer = Tokenizer<TestToken>(string: "é")

        XCTAssertNotNil(tokenizer.accept(.E_WITH_ACCENT))
    }

    func testMatchUnicodeEWithAccentFalse() {
        let tokenizer = Tokenizer<TestToken>(string: "  ")

        XCTAssertNil(tokenizer.accept(.E_WITH_ACCENT))
    }

    func testColumnParens() {
        let tokenizer = Tokenizer<TestToken>(string: "((((((((((")

        for c in 1...tokenizer.matchString.characters.count {
            XCTAssertEqual(tokenizer.line, 1)
            XCTAssertEqual(tokenizer.column, c)
            XCTAssertNotNil(tokenizer.accept(.LEFT_PAREN))
        }
    }

    func testColumnUnicodeGlobes() {
        let tokenizer = Tokenizer<TestToken>(string: "🌍🌍🌍🌍🌍🌍🌍🌍🌍")

        for c in 1...tokenizer.matchString.characters.count {
            XCTAssertEqual(tokenizer.line, 1)
            XCTAssertEqual(tokenizer.column, c)
            XCTAssertNotNil(tokenizer.accept(.GLOBE))
        }
    }

/// FIXME: THis is broken on Linux and crashes the tests.
///     testColumnUnicodeFlags() { func
///        let tokenizer = Tokenizer<TestToken>(string: "🇵🇷🇵🇷🇵🇷🇵🇷🇵🇷🇵🇷🇵🇷🇵🇷🇵🇷")
///
///        for c in 1...tokenizer.matchString.characters.count {
///            XCTAssertEqual(tokenizer.line, 1)
///            XCTAssertEqual(tokenizer.column, c)
///            XCTAssertNotNil(tokenizer.accept(.FLAG))
///        }
///    }

    func testColumnUnicodeEPlusAccent() {
        let tokenizer = Tokenizer<TestToken>(string: "e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}")

        for c in 1...tokenizer.matchString.characters.count {
            XCTAssertEqual(tokenizer.line, 1)
            XCTAssertEqual(tokenizer.column, c)
            XCTAssertNotNil(tokenizer.accept(.E_PLUS_ACCENT))
        }
    }

    func testColumnUnicodeEWithAccent() {
        let tokenizer = Tokenizer<TestToken>(string: "ééééééééé")

        for c in 1...tokenizer.matchString.characters.count {
            XCTAssertEqual(tokenizer.line, 1)
            XCTAssertEqual(tokenizer.column, c)
            XCTAssertNotNil(tokenizer.accept(.E_WITH_ACCENT))
        }
    }

    func testColumnUnicodeEPlusAccentCanonical() {
        let tokenizer = Tokenizer<TestToken>(string: "e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}e\u{0301}".precomposedStringWithCanonicalMapping)

        for c in 1...tokenizer.matchString.characters.count {
            XCTAssertEqual(tokenizer.line, 1)
            XCTAssertEqual(tokenizer.column, c)
            XCTAssertNotNil(tokenizer.accept(.E_WITH_ACCENT))
        }
    }

    func testLine() {
        let tokenizer = Tokenizer<TestToken>(string: "(((((\n(((((\n(((((\n(((((\n")

        for line in 1...4 {
            XCTAssertEqual(tokenizer.line, line)

            for column in 1...5 {
                XCTAssertEqual(tokenizer.column, column)
                XCTAssertNotNil(tokenizer.accept(.LEFT_PAREN))
            }
            XCTAssertNotNil(tokenizer.accept(.NEW_LINE))
        }
    }

    func testMatchString() {
        let input = "(((((((((("
        let expected = "((((("

        let tokenizer = Tokenizer<TestToken>(string: input)

        for _ in 1...5 {
            let _ = tokenizer.accept(.LEFT_PAREN)
        }

        XCTAssertEqual(tokenizer.matchString, expected)
    }
}
