/*
*   GFGeometryCollection.h
*
*   Copyright 2015 The Climate Corporation
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
*   Created by Tony Stone on 6/5/15.
*/

#import <Foundation/Foundation.h>
#import "GFGeometry.h"

/**
* @class       GFGeometryCollection
*
* @brief       A container class containing an array of GFGeometry objects.
*
* @author      Tony Stone
* @date        6/5/15
*/
@interface GFGeometryCollection : GFGeometry  // <NSFastEnumeration>

    /**
    *
    * Initialize this GFGeometryCollection with the NSArray of GFGeometry instances.
    *
    * @warning The array must not contain another GFGeometryCollection instance.
    *
    */
    - (instancetype)initWithArray:(NSArray *)array;

    /**
    * @returns The count of GDGeometry instances this collection contains.
    */
    - (NSUInteger) count;

    /**
    * @returns The GFGeometry instance at the index given.
    */
    - (GFGeometry *) geometryAtIndex:(NSUInteger)index;

    /**
    *
    * @returns The first GFGeometry instances contained in this collection or nil if the container is empty.
    */
    - (GFGeometry *) firstGeometry;

    /**
    *
    * @returns The last GFGeometry instances contained in this collection or nil if the container is empty.
    */
    - (GFGeometry *) lastGeometry;

@end