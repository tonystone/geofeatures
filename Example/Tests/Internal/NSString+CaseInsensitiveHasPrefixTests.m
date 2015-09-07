/*
*   NSString+CaseInsensitiveHasPrefixTests.m
*
*   Copyright 2015 Tony Stone
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
*   Created by Tony Stone on 09/07/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>
#import "NSString+CaseInsensitiveHasPrefix.h"

@interface NSString_CaseInsensitiveHasPrefix : XCTestCase
@end

@implementation NSString_CaseInsensitiveHasPrefix

    - (void) testHasPrefixCaseInsensitive {

        XCTAssertTrue ([@"ABCD" hasPrefix: @"aB" caseInsensitive: YES]);
        XCTAssertFalse([@"ABCD" hasPrefix: @"aB" caseInsensitive: NO]);
        XCTAssertTrue ([@"ABCD" hasPrefix: @"AB" caseInsensitive: NO]);
        
        XCTAssertFalse([@"ABCD" hasPrefix: @"CD" caseInsensitive: YES]);
        XCTAssertFalse([@"ABCD" hasPrefix: @"CD" caseInsensitive: NO]);
    }
@end

