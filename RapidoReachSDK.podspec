Pod::Spec.new do |s|

  s.name         = "RapidoReachSDK"
  s.version      = "1.0.2"
  s.summary      = "RapidoReach - monetize your app with in-app surveys."

  s.description  = <<-DESC
    RapidoReach provides a light & easy to use SDK that allows your app users to complete surveys in exchange for in-app content.
      DESC

  s.homepage     = "https://www.rapidoreach.com"

  s.license      = "Commercial"

  s.author             = { "Sudarshan Kondgekar" => "developers@rapidoreach.com" }

  s.platform     = :ios, "9.0"
  s.ios.deployment_target = '9.0'

  s.source = { :git => "https://github.com/rapidoreach/iOS-SDK-Podfile.git", :tag => s.version.to_s }

  s.frameworks = "AdSupport", "CoreTelephony", "Foundation", "JavaScriptCore", "Security", "SystemConfiguration", "UIKit", "Webkit"
  s.vendored_frameworks = 'RapidoReachSDK.xcframework'
 
  s.requires_arc = true

  s.xcconfig = { 
    "OTHER_LDFLAGS" => "-ObjC"
  }

end
