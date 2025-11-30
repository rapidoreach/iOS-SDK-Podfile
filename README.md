# RapidoReach iOS SDK

Lightweight rewarded survey offerwall SDK for iOS. Integrate to monetise your users with minimal effort and a native WebView experience.

## Installation (CocoaPods)

```ruby
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'RapidoReach', '~> 1.0.5'
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
- `RapidoReach.shared.updateBackend(baseURL: URL(string: "...")!)` to point to staging if needed.
- Request ATT consent (`RapidoReachDeviceInfo().requestTrackingPermission`) before accessing IDFA.

### Troubleshooting
- Call `configure(apiKey:user:)` before SDK methods.
- If no presenter is available, pass one explicitly to `presentOfferwall(from:)`.
