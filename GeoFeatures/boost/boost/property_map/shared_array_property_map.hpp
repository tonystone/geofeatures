//  Copyright (C) 2009 Trustees of Indiana University
//  Authors: Jeremiah Willcock, Andrew Lumsdaine

// Distributed under the Boost Software License, Version 1.0. (See
// accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

//  See http://www.boost.org/libs/property_map for documentation.

#ifndef BOOST_SHARED_ARRAY_PROPERTY_MAP_HPP
#define BOOST_SHARED_ARRAY_PROPERTY_MAP_HPP

#include <boost/smart_ptr/shared_array.hpp>
#include <boost/property_map/property_map.hpp>

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {

template <class T, class IndexMap>
class shared_array_property_map
  : public geofeatures_boost::put_get_helper<T&, shared_array_property_map<T, IndexMap> >
{
  public:
  typedef typename property_traits<IndexMap>::key_type key_type;
  typedef T value_type;
  typedef T& reference;
  typedef geofeatures_boost::lvalue_property_map_tag category;

  inline shared_array_property_map(): data(), index() {}

  explicit inline shared_array_property_map(
    size_t n,
    const IndexMap& _id = IndexMap())
  : data(new T[n]), index(_id) {}

  inline T& operator[](key_type v) const {
    return data[get(index, v)];
  }

  private:
  geofeatures_boost::shared_array<T> data;
  IndexMap index;
};

template <class T, class IndexMap>
shared_array_property_map<T, IndexMap>
make_shared_array_property_map(size_t n, const T&, const IndexMap& index) {
  return shared_array_property_map<T, IndexMap>(n, index);
}

} // end namespace geofeatures_boost

#endif // BOOST_SHARED_ARRAY_PROPERTY_MAP_HPP
