/**
*   GeometryCollection.hpp
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
*   Created by Tony Stone on 9/27/15.
*
*/


#ifndef __GeoFeatures_Allocator_HPP_
#define __GeoFeatures_Allocator_HPP_

#include <iostream>

namespace geofeatures {

    /**
     * Simple custom allocator which
     * will throw an "Objective-C" exception
     * rather than a C++ exception.
     */
    template <typename T>
    struct Allocator {
        using value_type = T;

        Allocator() = default;
        template <class U>
        Allocator(const Allocator<U>&) {}

        T* allocate(std::size_t n) {
            if (n <= std::numeric_limits<std::size_t>::max() / sizeof(T)) {
                if (auto ptr = std::malloc(n * sizeof(T))) {
                    return static_cast<T*>(ptr);
                }
            }
#ifdef __OBJC__
            @throw [[NSException alloc] initWithName: NSMallocException reason: @"Could not allocate memory." userInfo: nil];
#else
            throw std::bad_alloc();
#endif
        }
        void deallocate(T* ptr, std::size_t n) {
            std::free(ptr);
        }
    };

    template <typename T, typename U>
    inline bool operator == (const Allocator<T>&, const Allocator<U>&) {
        return true;
    }

    template <typename T, typename U>
    inline bool operator != (const Allocator<T>& a, const Allocator<U>& b) {
        return !(a == b);
    }

}   // namespace geofeatures

#endif //__GeoFeatures_Allocator_HPP_
