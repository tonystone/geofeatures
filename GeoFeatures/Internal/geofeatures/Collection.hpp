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
*/


#ifndef __GeoFeatures_Collection_HPP_
#define __GeoFeatures_Collection_HPP_

#include "Allocator.hpp"

#include <vector>

namespace geofeatures {

    /**
    * Base type for Collection classes
    */
    template <typename T, typename Allocator = geofeatures::Allocator<T>>
    class Collection : private std::vector<T, Allocator> {

    public:
        using std::vector<T, Allocator>::vector;
        
        inline virtual ~Collection() noexcept {}

        using typename std::vector<T, Allocator>::value_type;

        using typename std::vector<T, Allocator>::iterator;
        using typename std::vector<T, Allocator>::const_iterator;

        using std::vector<T, Allocator>::begin;
        using std::vector<T, Allocator>::end;
        using std::vector<T, Allocator>::cbegin;
        using std::vector<T, Allocator>::cend;

        using std::vector<T, Allocator>::front;
        using std::vector<T, Allocator>::back;

        using std::vector<T, Allocator>::size;
        using std::vector<T, Allocator>::empty;
        using std::vector<T, Allocator>::at;
        using std::vector<T, Allocator>::operator[];

        using std::vector<T, Allocator>::resize;
        using std::vector<T, Allocator>::push_back;
        using std::vector<T, Allocator>::insert;
        using std::vector<T, Allocator>::erase;
        using std::vector<T, Allocator>::clear;
    };


}   // namespace geofeatures

#endif //__GeoFeatures_Collection_HPP_
