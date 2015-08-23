#
# Be sure to run `pod lib lint GeoFeatures.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "GeoFeatures"
    s.version          = "0.2.7"
    s.summary          = "A full featured, lightweight, high performance geometry library for Objective-C"
    s.homepage         = "http://tonystone.github.io/geofeatures"
    s.license          = 'Apache License, Version 2.0'
    s.author           = "Tony Stone"
    s.source           = { :git => "https://github.com/tonystone/geofeatures.git", :tag => s.version.to_s }

    s.ios.deployment_target     = '6.0'
    s.osx.deployment_target     = '10.8'

    s.requires_arc = true

    s.source_files         = 'Pod/*'
    s.public_header_files  = 'Pod/*.h'
    s.preserve_path        = 'LICENSE'

    s.subspec 'Internal' do |sp|

        sp.subspec 'boost' do |ssp|
            ssp.header_mappings_dir = 'Pod/Internal/boost'
            ssp.source_files        = 'Pod/Internal/boost/boost/**/*.{h,hpp,ipp}'
            ssp.public_header_files = 'Pod/Internal/boost/boost/**/*.{h,hpp}'
            ssp.preserve_path       = 'Pod/Internal/boost/LICENSE_1_0.txt'
        end

        sp.subspec 'detail' do |ssp|
            ssp.dependency 'GeoFeatures/Internal/boost'

            ssp.header_mappings_dir = 'Pod/Internal/detail'
            ssp.source_files        = 'Pod/Internal/detail/*',
                                      'Pod/Internal/detail/geofeatures/**/*'
        end
    end

    s.frameworks = 'MapKit'

    #
    # Note: __ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES flag required to work around
    #       conflict with Apple headers defined in https://svn.boost.org/trac/boost/ticket/10471
    #
    s.xcconfig = {
        'GCC_C_LANGUAGE_STANDARD' => 'c11',
        'CLANG_CXX_LANGUAGE_STANDARD' => 'c++0x',
        'CLANG_CXX_LIBRARY' => 'libc++',
        'OTHER_LDFLAGS' => '-lc++',
        'OTHER_CFLAGS' => '-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0',
    }

end