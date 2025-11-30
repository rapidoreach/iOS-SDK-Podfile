# RapidoReach iOS SDK

Lightweight rewarded survey offerwall SDK for iOS. Integrate to monetise your users with minimal effort and a native WebView experience.

## Build the distributable XCFramework
If you need a standalone binary, run the provided helper:

```bash
cd cbiossdk
chmod +x scripts/build_xcframework.sh
scripts/build_xcframework.sh
```

The signed output lands in `cbiossdk/build/RapidoReach.xcframework`. Drag that folder into your Xcode project (Embed & Sign) and ensure `AdSupport`, `WebKit`, and `CoreTelephony` are linked.

## Installation (CocoaPods)

```ruby
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'RapidoReach', :git => 'https://bitbucket.org/vikash766/cbiossdk.git', :branch => 'main'
end
```

Run `pod install`, then open the generated workspace.

## Quick start

```swift
import RapidoReach

@main
class AppDelegate: UIResponder, UIApplicationDelegate, RapidoReachDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure once on app start
        RapidoReach.shared.configure(apiKey: "<YOUR_API_KEY>", user: "<YOUR_APP_USER_ID>")
        RapidoReach.shared.delegate = self
        RapidoReach.shared.fetchAppUserID() // registers user + fetches rewards
        return true
    }

    func showOfferwall(from controller: UIViewController) {
        RapidoReach.shared.presentOfferwall(from: controller, title: "Earn rewards")
    }

    // MARK: - RapidoReachDelegate (all methods have default empty implementations)
    func didGetRewards(_ reward: RapidoReachReward) { print("Total rewards: \(reward.total_rewards)") }
    func didSurveyAvailable(_ available: Bool) { print("Surveys available: \(available)") }
    func didOpenRewardCenter() { print("Offerwall opened") }
    func didClosedRewardCenter() { print("Offerwall closed") }
    func didGetError(_ error: RapidoReachError) { print("RapidoReach error: \(error.localizedDescription)") }
}
```

### Optional configuration
- `RapidoReach.shared.updateBackend(baseURL: URL(string: "...")!)` to point to staging.
- `RapidoReachDeviceInfo.requestTrackingPermission` lets you request ATT consent before we read the IDFA.

### Callbacks without delegates
You can also set functional callbacks:
```swift
RapidoReach.shared.setRewardCallback { reward in /* handle */ }
RapidoReach.shared.setrewardCenterOpenedCallback { /* handle */ }
RapidoReach.shared.setrewardCenterClosedCallback { /* handle */ }
RapidoReach.shared.setsurveysAvailableCallback { available in /* handle */ }
```

## Building a distributable XCFramework
Use the helper script to produce `build/RapidoReach.xcframework` (device + simulator slices, `BUILD_LIBRARY_FOR_DISTRIBUTION=YES`):

```bash
cd cbiossdk
./scripts/build_xcframework.sh
```

The script will:
1) generate an Xcode project from `Package.swift` if needed  
2) build Release for iOS device and simulator  
3) emit `build/RapidoReach.xcframework`

### Consuming the XCFramework manually
- Drag `RapidoReach.xcframework` into your app target (Embed & Sign).
- Ensure `AdSupport`, `CoreTelephony`, `WebKit`, and `UIKit` are linked (the podspec already includes them).
- Add `NSAppTransportSecurity` allowlist if your backend requires it.

## Behavior after this update
- CocoaPods now builds from Swift sources instead of a prebuilt binary, so simulator + device builds align.
- Stable request signing (sorted query items) to avoid occasional hash mismatches.
- Safer defaults: optional presenter resolution, better loading UX, and stronger parameter validation.
- Configurable backend URL + hash salt to switch between environments without code changes.

## Backend notes
No backend changes are required. Query parameters for the `enc` hash are now sorted; ensure the server mirrors that ordering when validating requests.

## Troubleshooting
- Always call `configure(apiKey:user:)` before hitting the API.
- If you cannot show the offerwall because there is no presenting controller, pass one explicitly to `presentOfferwall(from:)`.
- For ATT/IDFA access call `RapidoReachDeviceInfo().requestTrackingPermission` early in your app if you rely on advertising identifiers.

## CocoaPods publishing (token + workflow)
- Register with trunk (one-time) and verify via email:
  ```
  pod trunk register kvikash766@gmail.com 'Vikash Kumar' --description='Rapidoreach iOS pod'
  ```
  Click the verification link from `no-reply@cocoapods.org`.
- If the token file is not created automatically, write it manually:
  ```bash
  mkdir -p ~/.cocoapods/trunk
  cat > ~/.cocoapods/trunk/config.json <<'EOF'
  {
    "email": "kvikash766@gmail.com",
    "token": "<YOUR_TOKEN_HERE>",
    "created_at": "<UTC_TIMESTAMP>",
    "verified": true
  }
  EOF
  ```
- Confirm the session and token:
  ```
  pod trunk me
  cat ~/.cocoapods/trunk/config.json
  ```
- CI publishing: set secret `COCOAPODS_TRUNK_TOKEN` to the token value. Use the `Publish CocoaPod` workflow (`.github/workflows/pod-publish.yml`) to lint and push, optionally creating a Git tag/release.
