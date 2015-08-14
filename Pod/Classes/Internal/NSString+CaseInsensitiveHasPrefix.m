/**
*   NSString+CaseInsensitiveHasPrefix.m
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
*   Created by Tony Stone on 6/14/15.
*/

#import "NSString+CaseInsensitiveHasPrefix.h"


@implementation NSString (CaseInsensitiveHasPrefix)

    - (BOOL) hasPrefix: (NSString *) prefix caseInsensitive:(BOOL)caseInsensitive {

        if (!caseInsensitive)
            return [self hasPrefix:prefix];

        const NSStringCompareOptions options = NSAnchoredSearch|NSCaseInsensitiveSearch;
        NSRange prefixRange = [self rangeOfString:prefix options:options];

        return prefixRange.location == 0 && prefixRange.length > 0;
    }

@end