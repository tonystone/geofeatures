#
# Be sure to run `pod lib lint GeoFeatures.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GeoFeatures2"
  s.version          = "0.1.0"
  s.summary          = "A lightweight, high performance geometry library for Swift"

  s.homepage         = "https://github.com/tonystone/geofeatures"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "Tony Stone" => "https://github.com/tonystone" }
  s.source           = { :git => "https://github.com/tonystone/geofeatures2.git", :tag => s.version.to_s }

  s.ios.deployment_target     = '5.0'
  s.osx.deployment_target     = '10.7'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'

  s.requires_arc = true

  s.source_files = 'Pod/**/*'

end
