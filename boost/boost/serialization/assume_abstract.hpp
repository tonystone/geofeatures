#ifndef BOOST_SERIALIZATION_ASSUME_ABSTRACT_HPP
#define BOOST_SERIALIZATION_ASSUME_ABSTRACT_HPP

// MS compatible compilers support #pragma once
#if defined(_MSC_VER)
# pragma once
#endif

/////////1/////////2/////////3/////////4/////////5/////////6/////////7/////////8
// assume_abstract_class.hpp:

// (C) Copyright 2008 Robert Ramey
// Use, modification and distribution is subject to the Boost Software
// License, Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

//  See http://www.boost.org for updates, documentation, and revision history.

// this is useful for compilers which don't support the geofeatures_boost::is_abstract

#include <boost/type_traits/is_abstract.hpp>

#ifndef BOOST_NO_IS_ABSTRACT

// if there is an intrinsic is_abstract defined, we don't have to do anything
#define BOOST_SERIALIZATION_ASSUME_ABSTRACT(T)

// but forward to the "official" is_abstract
namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {
namespace serialization {
    template<class T>
    struct is_abstract : geofeatures_boost::is_abstract< T > {} ;
} // namespace serialization
} // namespace geofeatures_boost

#else
// we have to "make" one

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {
namespace serialization {
    template<class T>
    struct is_abstract : geofeatures_boost::false_type {};
} // namespace serialization
} // namespace geofeatures_boost

// define a macro to make explicit designation of this more transparent
#define BOOST_SERIALIZATION_ASSUME_ABSTRACT(T)        \
namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {                                     \
namespace serialization {                             \
template<>                                            \
struct is_abstract< T > : geofeatures_boost::true_type {};        \
template<>                                            \
struct is_abstract< const T > : geofeatures_boost::true_type {};  \
}}                                                    \
/**/

#endif // BOOST_NO_IS_ABSTRACT

#endif //BOOST_SERIALIZATION_ASSUME_ABSTRACT_HPP
