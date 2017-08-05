#
# Be sure to run `pod lib lint GeoFeatures.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GeoFeatures"
  s.version          = "2.0.0"
  s.summary          = "A lightweight, high performance geometry library for Swift"

  s.homepage         = "https://github.com/tonystone/geofeatures"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "Tony Stone" => "https://github.com/tonystone" }
  s.source           = { :git => "https://github.com/tonystone/geofeatures2.git", :tag => s.version.to_s }

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'

  s.requires_arc = true

  s.source_files = 'Sources/GeoFeatures/**/*.swift'
  s.preserve_paths = 'Sources/GeoFeatures/**/*.swift.gyb'

end
