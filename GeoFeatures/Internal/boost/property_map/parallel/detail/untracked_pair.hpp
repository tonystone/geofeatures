// Copyright (C) 2007 Matthias Troyer
//
// Use, modification and distribution is subject to the Boost Software
// License, Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
//
// This file contains helper data structures for use in transmitting
// properties. The basic idea is to optimize away any storage for the
// properties when no properties are specified.
#ifndef BOOST_PARALLEL_DETAIL_UNTRACKED_PAIR_HPP
#define BOOST_PARALLEL_DETAIL_UNTRACKED_PAIR_HPP

#include <boost/mpi/datatype.hpp>
#include <utility> // for std::pair
#include <boost/serialization/utility.hpp>

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace parallel { namespace detail {

/**
 * This structure is like std::pair, with the only difference
 * that tracking in the serialization library is turned off.
 */
 
template<typename T, typename U>
struct untracked_pair : public std::pair<T,U>
{
  untracked_pair() {}

  untracked_pair(const T& t, const U& u)
  : std::pair<T,U>(t,u) {}

  template<class T1, class U1>
  untracked_pair(std::pair<T1,U1> const& p)
  : std::pair<T,U>(p) {}  
};

template<typename T, typename U>
inline untracked_pair<T, U>
make_untracked_pair(const T& t, const U& u)
{
  return untracked_pair<T,U>(t,u);
}

} } } // end namespace geofeatures_boost::parallel::detail

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace mpi {

template<typename T, typename U>
struct is_mpi_datatype<geofeatures_boost::parallel::detail::untracked_pair<T, U> >
  : is_mpi_datatype<std::pair<T,U> > {};

} } // end namespace geofeatures_boost::mpi

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace serialization {

// pair
template<class Archive, class F, class S>
inline void serialize(
    Archive & ar,
    geofeatures_boost::parallel::detail::untracked_pair<F, S> & p,
    const unsigned int /* file_version */
){
    ar & geofeatures_boost::serialization::make_nvp("first", p.first);
    ar & geofeatures_boost::serialization::make_nvp("second", p.second);
}

template<typename T, typename U>
struct is_bitwise_serializable<
        geofeatures_boost::parallel::detail::untracked_pair<T, U> >
  : is_bitwise_serializable<std::pair<T, U> > {};

template<typename T, typename U>
struct implementation_level<geofeatures_boost::parallel::detail::untracked_pair<T, U> >
 : mpl::int_<object_serializable> {} ;

template<typename T, typename U>
struct tracking_level<geofeatures_boost::parallel::detail::untracked_pair<T, U> >
 : mpl::int_<track_never> {} ;

} } // end namespace geofeatures_boost::serialization

#endif // BOOST_PARALLEL_DETAIL_UNTRACKED_PAIR_HPP
