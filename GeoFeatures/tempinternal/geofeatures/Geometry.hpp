/**
*   Geometry.hpp
*
*   Copyright 2015 The Climate Corporation
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
*   Created by Tony Stone on 6/9/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#pragma once

#ifndef __Geometry_HPP_
#define __Geometry_HPP_

namespace geofeatures {

    /**
     * @class       Geometry
     *
     * @brief       Base abstract type for all Geometric types.
     *
     * @author      Tony Stone
     * @date        6/10/15
     */
    class Geometry {

    public:
        inline Geometry() noexcept  {}
        inline virtual ~Geometry() noexcept {};

    };

}   // namespace geofeatures

#endif //__Geometry_HPP_
