/*
*   GFIsValidTests.m
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
*   Created by Tony Stone on 04/14/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFIsValidTests : XCTestCase
@end

#define IsValidTest(T, input,expected) XCTAssertEqual([[[T alloc] initWithWKT: (input)] isValid], (expected))

@implementation GFIsValidTests


    - (void) testIsValid_WithValidPoint0 {
        IsValidTest(GFPoint, @"POINT(0 0)", true);
    }

    - (void) testIsValid_WithValidPoint1 {
        IsValidTest(GFPoint, @"POINT(1 1)", true);
    }

    - (void) testIsValid_WithEmptyPoint {
        IsValidTest(GFPoint, @"POINT EMPTY", true);
    }

    - (void) testIsValid_WithValidMultiPoint {
        IsValidTest(GFMultiPoint, @"MULTIPOINT(0 0,1 1)", true);
    }

    - (void) testIsValid_WithEmptyMultiPoint {
        IsValidTest(GFMultiPoint, @"MULTIPOINT EMPTY", true);
    }

    - (void) testIsValid_WithValidLineString {
        IsValidTest(GFLineString, @"LINESTRING(0 0,1 1)", true);
    }

    - (void) testIsValid_WithEmptyLineString {
        IsValidTest(GFLineString, @"LINESTRING EMPTY", false);
    }

    - (void) testIsValid_WithValidMultiLineString {
        IsValidTest(GFMultiLineString, @"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", true);
    }

    - (void) testIsValid_WithEmptyMultiLineString {
        IsValidTest(GFMultiLineString, @"MULTILINESTRING EMPTY", true);
    }

    - (void) testIsValid_WithValidPolygon {
        IsValidTest(GFPolygon, @"POLYGON((0 0,0 7,4 2,2 0,0 0))", true);
    }

    - (void) testIsValid_WithInvalidBigPolygon {
        IsValidTest(GFPolygon, @"POLYGON((-91.5494 42.0698,-91.5494 42.0698,-91.549 42.0698,-91.5489 42.0697,-91.5488 42.0696,-91.5485 42.0696,-91.5481 42.0695,-91.5477 42.0694,-91.5475 42.0694,-91.5474 42.0693,-91.5472 42.0692,-91.547 42.0691,-91.547 42.0685,-91.547 42.0684,-91.5468 42.0682,-91.5467 42.0682,-91.5465 42.0681,-91.5463 42.0679,-91.5462 42.0678,-91.5461 42.0677,-91.546 42.0675,-91.5457 42.0674,-91.5456 42.0673,-91.5456 42.0672,-91.5456 42.0671,-91.5456 42.067,-91.5457 42.0669,-91.5458 42.0668,-91.546 42.0667,-91.5463 42.0666,-91.5464 42.0665,-91.5465 42.0664,-91.5465 42.0663,-91.5465 42.066,-91.5464 42.0657,-91.5464 42.0656,-91.5464 42.0655,-91.5465 42.0654,-91.5466 42.0652,-91.5469 42.065,-91.547 42.065,-91.547 42.0649,-91.547 42.0648,-91.5468 42.0647,-91.5477 42.0647,-91.5499 42.0647,-91.5499 42.0649,-91.5498 42.0648,-91.5495 42.0648,-91.5493 42.0648,-91.5491 42.0649,-91.5489 42.065,-91.5486 42.065,-91.5484 42.065,-91.5483 42.0651,-91.5483 42.0652,-91.5483 42.0653,-91.5485 42.0654,-91.5487 42.0654,-91.5489 42.0654,-91.549 42.0654,-91.5491 42.0655,-91.5491 42.0656,-91.5491 42.0657,-91.549 42.0657,-91.5489 42.0658,-91.5486 42.0658,-91.5484 42.0658,-91.5483 42.0658,-91.5481 42.0659,-91.5479 42.0661,-91.5479 42.0662,-91.5479 42.0664,-91.548 42.0665,-91.5481 42.0666,-91.5482 42.0667,-91.5485 42.0667,-91.549 42.0668,-91.5491 42.0668,-91.5491 42.0668,-91.5489 42.0668,-91.5489 42.0668,-91.5489 42.0673,-91.549 42.0679,-91.5492 42.0696,-91.5494 42.0698))", false);
    }

    - (void) testIsValid_WithEmptyPolygon {
        IsValidTest(GFPolygon, @"POLYGON EMPTY", false);
    }

    - (void) testIsValid_WithValidMultiPolygon {
        IsValidTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((10 10,10 17,14 12,12 10,10 10)))", true);
    }

    - (void) testIsValid_WithInvalidMultiPolygon {
        IsValidTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((0 0,0 7,4 2,2 0,0 0)))", false);
    }

    - (void) testIsValid_WithInvalidBigMultiPolygon {
        IsValidTest(GFMultiPolygon, @"MULTIPOLYGON(((-91.5354 42.0653,-91.5354 42.0653,-91.5356 42.0653,-91.5358 42.0652,-91.536 42.0651,-91.5362 42.0651,-91.5364 42.0651,-91.5368 42.0652,-91.5371 42.0651,-91.5375 42.0651,-91.5377 42.0651,-91.5378 42.0651,-91.5378 42.0652,-91.5379 42.0653,-91.5379 42.0654,-91.5378 42.0656,-91.5378 42.0656,-91.5377 42.0657,-91.5373 42.066,-91.5372 42.0661,-91.537 42.0664,-91.5369 42.0665,-91.5368 42.0666,-91.5365 42.0667,-91.5364 42.067,-91.5362 42.067,-91.5361 42.0672,-91.5358 42.0674,-91.5356 42.0675,-91.5354 42.0676,-91.5354 42.0653)),((-91.5499 42.0661,-91.5499 42.0666,-91.5499 42.067,-91.5497 42.067,-91.5496 42.0668,-91.5491 42.0668,-91.549 42.0668,-91.5485 42.0667,-91.5482 42.0667,-91.5481 42.0666,-91.548 42.0665,-91.5479 42.0664,-91.5479 42.0662,-91.5479 42.0661,-91.5481 42.0659,-91.5483 42.0658,-91.5484 42.0658,-91.5486 42.0658,-91.5489 42.0658,-91.549 42.0657,-91.5491 42.0657,-91.5491 42.0656,-91.5491 42.0655,-91.549 42.0654,-91.5489 42.0654,-91.5487 42.0654,-91.5485 42.0654,-91.5483 42.0653,-91.5483 42.0652,-91.5483 42.0651,-91.5484 42.065,-91.5486 42.065,-91.5489 42.065,-91.5491 42.0649,-91.5493 42.0648,-91.5495 42.0648,-91.5498 42.0648,-91.5499 42.0649,-91.5499 42.0661)),((-91.5379 42.0663,-91.538 42.0663,-91.5382 42.0665,-91.5383 42.0667,-91.5383 42.0668,-91.5383 42.0669,-91.5382 42.067,-91.538 42.0672,-91.5379 42.0672,-91.5381 42.0669,-91.5381 42.0666,-91.538 42.067,-91.5378 42.0673,-91.5377 42.0673,-91.5371 42.0676,-91.5369 42.0678,-91.5361 42.0678,-91.5363 42.0676,-91.5365 42.0674,-91.5369 42.0672,-91.5373 42.0669,-91.5374 42.0668,-91.5374 42.0668,-91.5376 42.0666,-91.5377 42.0664,-91.5378 42.0664,-91.5379 42.0663)),((-91.5368 42.0678,-91.5367 42.0679,-91.5366 42.068,-91.5364 42.0684,-91.5363 42.0685,-91.5362 42.0686,-91.5361 42.0687,-91.536 42.0687,-91.5357 42.0687,-91.5356 42.0686,-91.5354 42.0684,-91.5354 42.0684,-91.5354 42.0683,-91.5358 42.068,-91.5359 42.0679,-91.536 42.0678,-91.5368 42.0678)))", false);
    }

    - (void) testIsValid_WithEmptyMultiPolygon {
        IsValidTest(GFMultiPolygon, @"MULTIPOLYGON EMPTY", true);
    }

    - (void) testValid_WithRing {
        IsValidTest(GFRing, @"LINESTRING(0 0,0 7,4 2,2 0,0 0)", true);
    }

    - (void) testIsValid_WithEmptyRing {
        IsValidTest(GFRing, @"LINESTRING EMPTY", false);
    }

    - (void) testIsValid_WithGeometryCollection_AllValid {
        IsValidTest(GFGeometryCollection , @"GEOMETRYCOLLECTION(POINT(0 0),MULTIPOINT(0 0,1 1),LINESTRING(0 0,1 1),MULTILINESTRING((0 0,1 1),(-1 0,1 0)),POLYGON((0 0,0 7,4 2,2 0,0 0)),MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((10 10,10 17,14 12,12 10,10 10))))", true);
    }

    - (void) testIsValid_WithGeometryCollection_Invalid {
        IsValidTest(GFGeometryCollection , @"GEOMETRYCOLLECTION(POINT(0 0),MULTIPOINT(0 0,1 1),LINESTRING(),MULTILINESTRING((0 0,1 1),(-1 0,1 0)),POLYGON((0 0,0 7,4 2,2 0,0 0)),MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((10 10,10 17,14 12,12 10,10 10))))", false);
    }
    - (void) testIsValid_WithGeometryCollection_Empty {
        IsValidTest(GFGeometryCollection , @"GEOMETRYCOLLECTION EMPTY", true);
    }

@end