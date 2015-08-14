/*
*   GFLineStringAbstract.h
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
*   Created by Tony Stone on 6/6/15.
*/

#import <Foundation/Foundation.h>
#import "GFGeometry.h"

/**
 * @class       GFLineStringAbstract
 *
 * @brief       An Abstract LineString implementation.
 *
 * An Abstract LineString implementation which should not
 * be instantiated on it's own.
 *
 * @warning Do not instantiate this abstract class.
 *
 * @author      Tony Stone
 * @date        6/6/15
 */
@interface GFLineStringAbstract : GFGeometry
@end