/*
*   GFMutableBoxTests.m
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

@interface GFMutableBoxTests : XCTestCase
@end

@implementation GFMutableBoxTests

    - (void) testMutableCopyClass {
        XCTAssertTrue([[[[GFBox alloc] initWithWKT: @"BOX(1 1,3 3)"] mutableCopy] isMemberOfClass: [GFMutableBox class]]);
    }

    - (void) testMutableCopyValue {
        XCTAssertEqualObjects([[[[GFBox alloc] initWithWKT: @"BOX(1 1,3 3)"] mutableCopy] toWKTString], @"POLYGON((1 1,1 3,3 3,3 1,1 1))");
    }

    - (void) testSetMinCorner {
        GFMutableBox * box = [[GFMutableBox alloc] init];

        [box setMinCorner: [[GFPoint alloc] initWithX: 1.0 y: 1.0]];

        XCTAssertEqual([[box minCorner] x], 1.0);
        XCTAssertEqual([[box minCorner] y], 1.0);
    }

    - (void) testSetY {
        GFMutableBox * box = [[GFMutableBox alloc] init];

        [box setMaxCorner: [[GFPoint alloc] initWithX: 3.0 y: 3.0]];

        XCTAssertEqual([[box maxCorner] x], 3.0);
        XCTAssertEqual([[box maxCorner] y], 3.0);
    }

@end

