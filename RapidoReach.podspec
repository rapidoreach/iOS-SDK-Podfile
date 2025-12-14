#
# Be sure to run `pod lib lint RapidoReach.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RapidoReach'
  s.version          = '1.0.8'
  s.summary          = 'Rewarded survey offerwall SDK for iOS apps.'
  s.readme           = "https://raw.githubusercontent.com/rapidoreach/iOS-SDK-Podfile/v#{s.version}/README.md"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
RapidoReach surfaces rewarded survey offerwalls so you can monetise your users with minimal effort.
The SDK handles user registration, survey availability checks, presentation, and reward callbacks.
DESC

  s.homepage         = 'https://github.com/rapidoreach/iOS-SDK-Podfile'
  s.license          = { :type => 'MIT' }
  s.author           = { 'RapidoReach' => 'support@rapidoreach.com' }
  s.source           = { :git => 'https://github.com/rapidoreach/iOS-SDK-Podfile.git', :tag => "v#{s.version}" }
  s.platform         = :ios

  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5.0', '5.3', '5.9']

  s.source_files = 'Sources/RapidoReach/**/*.{swift}'
  s.frameworks = 'UIKit', 'WebKit', 'AdSupport', 'CoreTelephony'
  s.requires_arc = true
end
