// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2011-2015 Akira Takahashi
// Copyright (c) 2011-2015 Barend Gehrels, Amsterdam, the Netherlands.

// This file was modified by Oracle on 2015.
// Modifications copyright (c) 2015, Oracle and/or its affiliates.

// Contributed and/or modified by Menelaos Karavelas, on behalf of Oracle

// Use, modification and distribution is subject to the Boost Software License,
// Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_GEOMETRY_GEOMETRIES_ADAPTED_FUSION_HPP
#define BOOST_GEOMETRY_GEOMETRIES_ADAPTED_FUSION_HPP


#include <cstddef>

#include <boost/core/enable_if.hpp>

#include <boost/fusion/include/is_sequence.hpp>
#include <boost/fusion/include/size.hpp>
#include <boost/fusion/include/tag_of.hpp>
#include <boost/fusion/include/front.hpp>
#include <boost/fusion/include/at.hpp>
#include <boost/fusion/mpl.hpp>

#include <boost/mpl/and.hpp>
#include <boost/mpl/count_if.hpp>
#include <boost/mpl/front.hpp>
#include <boost/mpl/placeholders.hpp>
#include <boost/mpl/pop_front.hpp>
#include <boost/mpl/size.hpp>

#include <boost/type_traits/is_same.hpp>
#include <boost/type_traits/remove_reference.hpp>

#include <boost/geometry/core/access.hpp>
#include <boost/geometry/core/coordinate_dimension.hpp>
#include <boost/geometry/core/coordinate_system.hpp>
#include <boost/geometry/core/coordinate_type.hpp>
#include <boost/geometry/core/point_type.hpp>
#include <boost/geometry/core/tags.hpp>


namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry
{

namespace fusion_adapt_detail
{

template <class Sequence>
struct all_same :
    geofeatures_boost::mpl::bool_<
        geofeatures_boost::mpl::count_if<
            Sequence,
            geofeatures_boost::is_same<
                typename geofeatures_boost::mpl::front<Sequence>::type,
                geofeatures_boost::mpl::_
            >
        >::value == geofeatures_boost::mpl::size<Sequence>::value
    >
{};

template <class Sequence>
struct is_coordinate_size : geofeatures_boost::mpl::bool_<
            geofeatures_boost::fusion::result_of::size<Sequence>::value == 2 ||
            geofeatures_boost::fusion::result_of::size<Sequence>::value == 3> {};

template<typename Sequence>
struct is_fusion_sequence
    : geofeatures_boost::mpl::and_<geofeatures_boost::fusion::traits::is_sequence<Sequence>,
                fusion_adapt_detail::is_coordinate_size<Sequence>,
                fusion_adapt_detail::all_same<Sequence> >
{};


} // namespace fusion_adapt_detail


#ifndef DOXYGEN_NO_TRAITS_SPECIALIZATIONS
namespace traits
{

// Boost Fusion Sequence, 2D or 3D
template <typename Sequence>
struct coordinate_type
    <
        Sequence,
        typename geofeatures_boost::enable_if
            <
                fusion_adapt_detail::is_fusion_sequence<Sequence>
            >::type
    >
{
    typedef typename geofeatures_boost::mpl::front<Sequence>::type type;
};


template <typename Sequence>
struct dimension
    <
        Sequence,
        typename geofeatures_boost::enable_if
            <
                fusion_adapt_detail::is_fusion_sequence<Sequence>
            >::type
    > : geofeatures_boost::mpl::size<Sequence>
{};


template <typename Sequence, std::size_t Dimension>
struct access
    <
        Sequence,
        Dimension,
        typename geofeatures_boost::enable_if
            <
                fusion_adapt_detail::is_fusion_sequence<Sequence>
            >::type
    >
{
    typedef typename coordinate_type<Sequence>::type ctype;

    static inline ctype get(Sequence const& point)
    {
        return geofeatures_boost::fusion::at_c<Dimension>(point);
    }

    template <class CoordinateType>
    static inline void set(Sequence& point, CoordinateType const& value)
    {
        geofeatures_boost::fusion::at_c<Dimension>(point) = value;
    }
};


template <typename Sequence>
struct tag
    <
        Sequence,
        typename geofeatures_boost::enable_if
            <
                fusion_adapt_detail::is_fusion_sequence<Sequence>
            >::type
    >
{
    typedef point_tag type;
};


} // namespace traits

#endif // DOXYGEN_NO_TRAITS_SPECIALIZATIONS


}} // namespace geofeatures_boost::geometry


// Convenience registration macro to bind a Fusion sequence to a CS
#define BOOST_GEOMETRY_REGISTER_BOOST_FUSION_CS(CoordinateSystem) \
    namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry { namespace traits { \
    template <typename Sequence> \
    struct coordinate_system \
               < \
                   Sequence, \
                   typename geofeatures_boost::enable_if \
                       < \
                           fusion_adapt_detail::is_fusion_sequence<Sequence> \
                       >::type \
               > \
    { typedef CoordinateSystem type; }; \
    }}}


#endif // BOOST_GEOMETRY_GEOMETRIES_ADAPTED_FUSION_HPP