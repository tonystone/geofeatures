/*
*   GFMutablePointTests.m
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
*   Created by Tony Stone on 09/23/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFMutablePointTests : XCTestCase
@end

@implementation GFMutablePointTests

    - (void) testMutableCopyClass {

        XCTAssertTrue([[[[GFPoint alloc] initWithWKT: @"POINT(103 2)"] mutableCopy] isMemberOfClass: [GFMutablePoint class]]);
    }

    - (void) testMutableCopyValue {
        XCTAssertEqualObjects([[[[GFPoint alloc] initWithWKT: @"POINT(103 2)"] mutableCopy] toWKTString], @"POINT(103 2)");
    }

    - (void) testSetX {
        GFMutablePoint * point = [[GFMutablePoint alloc] init];

        [point setX: 103.0];

        XCTAssertEqual([point x], 103.0);
    }

    - (void) testSetY {
        GFMutablePoint * point = [[GFMutablePoint alloc] init];

        [point setY: 2.0];

        XCTAssertEqual([point y], 2.0);
    }

@end

