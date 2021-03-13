#
# Be sure to run `pod lib lint RapidoReachSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RapidoReachSDK'
  s.version          = '1.0.2'
  s.summary          = 'A short description of RapidoReachSDK SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Survey SDK
                       DESC

  s.homepage         = 'https://bitbucket.org/vikash766/cbiossdk'
  s.license          = { :type => 'MIT' }
  s.author           = { 'yasirmturk' => 'yasirmturk@gmail.com' }
  s.source           = { :git => 'https://bitbucket.org/vikash766/cbiossdk.git', :tag => s.version.to_s }
  s.platform         = :ios

  s.ios.deployment_target = '9.0'
  s.ios.vendored_frameworks = 'RapidoReachSDK.xcframework'
end
