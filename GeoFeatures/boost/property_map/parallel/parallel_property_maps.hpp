//  (C) Copyright Jeremy Siek 1999-2001.
//  Copyright (C) 2006 Trustees of Indiana University
//  Authors: Douglas Gregor and Jeremy Siek

// Distributed under the Boost Software License, Version 1.0. (See
// accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

//  See http://www.boost.org/libs/property_map for documentation.

#ifndef BOOST_PROPERTY_MAP_PARALLEL_PROPERTY_MAPS_HPP
#define BOOST_PROPERTY_MAP_PARALLEL_PROPERTY_MAPS_HPP

// Parallel property maps moved over from <boost/property_map/property_map.hpp>
// as part of refactoring out all parallel code from sequential property map
// library.

#include <boost/assert.hpp>
#include <boost/config.hpp>
#include <boost/static_assert.hpp>
#include <cstddef>
#include <boost/detail/iterator.hpp>
#include <boost/concept_check.hpp>
#include <boost/concept_archetype.hpp>
#include <boost/mpl/assert.hpp>
#include <boost/mpl/or.hpp>
#include <boost/mpl/and.hpp>
#include <boost/mpl/has_xxx.hpp>
#include <boost/type_traits/is_same.hpp>
#include <boost/property_map/property_map.hpp>

#include <boost/property_map/parallel/distributed_property_map.hpp>
#include <boost/property_map/parallel/local_property_map.hpp>

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {
/** Distributed iterator property map.
 *
 * This specialization of @ref iterator_property_map builds a
 * distributed iterator property map given the local index maps
 * generated by distributed graph types that automatically have index
 * properties. 
 *
 * This specialization is useful when creating external distributed
 * property maps via the same syntax used to create external
 * sequential property maps.
 */
template<typename RandomAccessIterator, typename ProcessGroup,
         typename GlobalMap, typename StorageMap, 
         typename ValueType, typename Reference>
class iterator_property_map
        <RandomAccessIterator, 
         local_property_map<ProcessGroup, GlobalMap, StorageMap>,
         ValueType, Reference>
  : public parallel::distributed_property_map
             <ProcessGroup, 
              GlobalMap, 
              iterator_property_map<RandomAccessIterator, StorageMap,
                                    ValueType, Reference> >
{
  typedef iterator_property_map<RandomAccessIterator, StorageMap, 
                                ValueType, Reference> local_iterator_map;

  typedef parallel::distributed_property_map<ProcessGroup, GlobalMap,
                                             local_iterator_map> inherited;

  typedef local_property_map<ProcessGroup, GlobalMap, StorageMap>
    index_map_type;
  typedef iterator_property_map self_type;

public:
  iterator_property_map() { }

  iterator_property_map(RandomAccessIterator cc, const index_map_type& id)
    : inherited(id.process_group(), id.global(), 
                local_iterator_map(cc, id.base())) { }
};

/** Distributed iterator property map.
 *
 * This specialization of @ref iterator_property_map builds a
 * distributed iterator property map given a distributed index
 * map. Only the local portion of the distributed index property map
 * is utilized.
 *
 * This specialization is useful when creating external distributed
 * property maps via the same syntax used to create external
 * sequential property maps.
 */
template<typename RandomAccessIterator, typename ProcessGroup,
         typename GlobalMap, typename StorageMap, 
         typename ValueType, typename Reference>
class iterator_property_map<
        RandomAccessIterator, 
        parallel::distributed_property_map<ProcessGroup,GlobalMap,StorageMap>,
        ValueType, Reference
      >
  : public parallel::distributed_property_map
             <ProcessGroup, 
              GlobalMap,
              iterator_property_map<RandomAccessIterator, StorageMap,
                                    ValueType, Reference> >
{
  typedef iterator_property_map<RandomAccessIterator, StorageMap,
                                ValueType, Reference> local_iterator_map;

  typedef parallel::distributed_property_map<ProcessGroup, GlobalMap,
                                             local_iterator_map> inherited;

  typedef parallel::distributed_property_map<ProcessGroup, GlobalMap, 
                                             StorageMap>
    index_map_type;

public:
  iterator_property_map() { }

  iterator_property_map(RandomAccessIterator cc, const index_map_type& id)
    : inherited(id.process_group(), id.global(),
                local_iterator_map(cc, id.base())) { }
};

namespace parallel {
// Generate an iterator property map with a specific kind of ghost
// cells
template<typename RandomAccessIterator, typename ProcessGroup,
         typename GlobalMap, typename StorageMap>
distributed_property_map<ProcessGroup, 
                         GlobalMap,
                         iterator_property_map<RandomAccessIterator, 
                                               StorageMap> >
make_iterator_property_map(RandomAccessIterator cc,
                           local_property_map<ProcessGroup, GlobalMap, 
                                              StorageMap> index_map)
{
  typedef distributed_property_map<
            ProcessGroup, GlobalMap,
            iterator_property_map<RandomAccessIterator, StorageMap> >
    result_type;
  return result_type(index_map.process_group(), index_map.global(),
                     make_iterator_property_map(cc, index_map.base()));
}

} // end namespace parallel

/** Distributed safe iterator property map.
 *
 * This specialization of @ref safe_iterator_property_map builds a
 * distributed iterator property map given the local index maps
 * generated by distributed graph types that automatically have index
 * properties. 
 *
 * This specialization is useful when creating external distributed
 * property maps via the same syntax used to create external
 * sequential property maps.
 */
template<typename RandomAccessIterator, typename ProcessGroup,
         typename GlobalMap, typename StorageMap, typename ValueType,
         typename Reference>
class safe_iterator_property_map
        <RandomAccessIterator, 
         local_property_map<ProcessGroup, GlobalMap, StorageMap>,
         ValueType, Reference>
  : public parallel::distributed_property_map
             <ProcessGroup, 
              GlobalMap,
              safe_iterator_property_map<RandomAccessIterator, StorageMap,
                                         ValueType, Reference> >
{
  typedef safe_iterator_property_map<RandomAccessIterator, StorageMap, 
                                     ValueType, Reference> local_iterator_map;

  typedef parallel::distributed_property_map<ProcessGroup, GlobalMap,
                                             local_iterator_map> inherited;

  typedef local_property_map<ProcessGroup, GlobalMap, StorageMap> index_map_type;

public:
  safe_iterator_property_map() { }

  safe_iterator_property_map(RandomAccessIterator cc, std::size_t n, 
                             const index_map_type& id)
    : inherited(id.process_group(), id.global(),
                local_iterator_map(cc, n, id.base())) { }
};

/** Distributed safe iterator property map.
 *
 * This specialization of @ref safe_iterator_property_map builds a
 * distributed iterator property map given a distributed index
 * map. Only the local portion of the distributed index property map
 * is utilized.
 *
 * This specialization is useful when creating external distributed
 * property maps via the same syntax used to create external
 * sequential property maps.
 */
template<typename RandomAccessIterator, typename ProcessGroup,
         typename GlobalMap, typename StorageMap, 
         typename ValueType, typename Reference>
class safe_iterator_property_map<
        RandomAccessIterator, 
        parallel::distributed_property_map<ProcessGroup,GlobalMap,StorageMap>,
        ValueType, Reference>
  : public parallel::distributed_property_map
             <ProcessGroup, 
              GlobalMap,
              safe_iterator_property_map<RandomAccessIterator, StorageMap,
                                         ValueType, Reference> >
{
  typedef safe_iterator_property_map<RandomAccessIterator, StorageMap,
                                     ValueType, Reference> local_iterator_map;

  typedef parallel::distributed_property_map<ProcessGroup, GlobalMap,
                                             local_iterator_map> inherited;

  typedef parallel::distributed_property_map<ProcessGroup, GlobalMap, 
                                             StorageMap>
    index_map_type;

public:
  safe_iterator_property_map() { }

  safe_iterator_property_map(RandomAccessIterator cc, std::size_t n, 
                             const index_map_type& id)
    : inherited(id.process_group(), id.global(), 
                local_iterator_map(cc, n, id.base())) { }
};                                            

}

#include <boost/property_map/vector_property_map.hpp>

#endif /* BOOST_PROPERTY_MAP_PARALLEL_PROPERTY_MAPS_HPP */

