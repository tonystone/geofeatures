#
# Be sure to run `pod lib lint GeoFeatures.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name              = "GeoFeatures"
    s.version           = "1.6.4"
    s.summary           = "A lightweight, high performance geometry library for Objective-C"
    s.homepage          = "https://github.com/tonystone/geofeatures"
    s.license           = 'Apache License, Version 2.0'
    s.author            = "Tony Stone"
    s.source            = { :git => "https://github.com/tonystone/geofeatures.git", :tag => s.version.to_s }

    s.ios.deployment_target     = '6.0'
    s.osx.deployment_target     = '10.7'

    s.requires_arc = true

    s.public_header_files  = 'GeoFeatures/*.h'
    s.private_header_files = 'GeoFeatures/internal/**/*.{hpp,h}'
    s.source_files         = 'GeoFeatures/**/*'
    s.preserve_paths       = 'LICENSE_BOOST_1_0'

    s.exclude_files        =    'GeoFeatures/**/*.pl',
                                'GeoFeatures/internal/boost/test/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/bcc/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/bcc551/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/bcc_pre590/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/dmc/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/msvc60/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/msvc70/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/mwcw/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/np_ctps/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/no_ttp/**/*',
                                'GeoFeatures/internal/boost/mpl/aux_/preprocessed/plain/**/*',
                                'GeoFeatures/internal/boost/mpl/vector/aux_/preprocessed/plain/**/*',
                                'GeoFeatures/internal/boost/mpl/vector/aux_/preprocessed/no_ctps/**/*',
                                'GeoFeatures/internal/boost/parameter/aux_/preprocessed/**/*',
                                'GeoFeatures/internal/boost/fusion/container/deque/detail/cpp03/preprocessed/**/*',
                                'GeoFeatures/internal/boost/fusion/container/list/detail/cpp03/preprocessed/**/*',
                                'GeoFeatures/internal/boost/fusion/container/map/detail/cpp03/preprocessed/**/*',
                                'GeoFeatures/internal/boost/fusion/container/set/detail/cpp03/preprocessed/**/*',
                                'GeoFeatures/internal/boost/fusion/container/vector/detail/cpp03/preprocessed/**/*'

    s.frameworks = 'MapKit'

    #
    # Note: __ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES flag required to work around
    #       conflict with Apple headers defined in https://svn.boost.org/trac/boost/ticket/10471
    #
    s.pod_target_xcconfig = {
       'GCC_C_LANGUAGE_STANDARD' => 'c11',
        'CLANG_CXX_LANGUAGE_STANDARD' => 'c++0x',
        'CLANG_CXX_LIBRARY' => 'libc++',
        'OTHER_LDFLAGS' => '-lc++',
        'OTHER_CFLAGS' => '-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0',
        'HEADER_SEARCH_PATHS' => '$(inherited) "$(PODS_ROOT)/GeoFeatures/GeoFeatures/internal" "$(PODS_ROOT)/../../GeoFeatures/internal"',
    }
end