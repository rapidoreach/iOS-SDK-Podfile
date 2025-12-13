# RapidoReach iOS SDK

Lightweight rewarded survey offerwall SDK for iOS. Integrate to monetise your users with minimal effort and a native WebView experience.

## Installation (CocoaPods)

```ruby
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'RapidoReach', '~> 1.0.6'
end
```

Run `pod install`, then open the generated workspace.

## Quick start

```swift
import RapidoReach

@main
class AppDelegate: UIResponder, UIApplicationDelegate, RapidoReachDelegate, RapidoReachRewardDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Optional: Point to staging or local dev environment before configuring
        // RapidoReach.shared.updateBackend(baseURL: URL(string: "http://localhost:8083")!)

        // Configure once on app start
        RapidoReach.shared.configure(apiKey: "<YOUR_API_KEY>", user: "<YOUR_APP_USER_ID>")
        
        // Set delegates
        RapidoReach.shared.delegate = self
        RapidoReach.shared.rewardDelegate = self
        
        // Register user and fetch initial state
        RapidoReach.shared.fetchAppUserID() 
        
        return true
    }

    func showOfferwall(from controller: UIViewController) {
        // Present the Offerwall (Survey Wall)
        RapidoReach.shared.presentOfferwall(from: controller, title: "Earn Rewards")
    }

    // MARK: - RapidoReachDelegate
    func didGetUser(_ user: RapidoReachUser) {
        print("User registered: \(user.id)")
    }
    
    func didSurveyAvailable(_ available: Bool) {
        print("Surveys available: \(available)")
    }
    
    func didOpenRewardCenter() {
        print("Offerwall opened")
    }
    
    func didClosedRewardCenter() {
        print("Offerwall closed")
    }
    
    func didGetError(_ error: RapidoReachError) {
        print("RapidoReach error: \(error.localizedDescription)")
    }

    // MARK: - RapidoReachRewardDelegate
    func onRewards(_ rewards: [RapidoReachRewardPayload]) {
        for reward in rewards {
            print("Received reward: \(reward.rewardAmount) \(reward.currencyName ?? "coins")")
        }
    }
}
```

## Advanced Usage

### Placements
Check if content is available for a specific placement tag before showing it.

```swift
RapidoReach.shared.canShowContent(tag: "default") { result in
    switch result {
    case .success(let canShow):
        if canShow {
            print("Placement is ready")
        } else {
            print("Placement not ready")
        }
    case .failure(let error):
        print("Error checking placement: \(error)")
    }
}
```

### User Attributes
Send user attributes for better survey targeting.

```swift
let attributes: [String: Any] = [
    "gender": "male",
    "age": 25,
    "zip": "90210"
]
RapidoReach.shared.sendUserAttributes(attributes)
```

### Custom Parameters
Pass custom parameters when opening the offerwall. These are passed through to the survey providers.

```swift
let customParams: [String: Any] = ["sub_id": "12345"]
RapidoReach.shared.presentOfferwall(from: self, title: "Rewards", customParameters: customParams)
```

### Specific Surveys
You can list available surveys and get a direct link to a specific survey.

```swift
RapidoReach.shared.listSurveys(tag: "default") { result in
    if case .success(let surveys) = result {
        if let firstSurvey = surveys.first, let id = firstSurvey["survey_identifier"] as? String {
            // Get the entry URL for this specific survey
            RapidoReach.shared.showSurvey(surveyId: id, tag: "default") { urlResult in
                if case .success(let url) = urlResult {
                    // Open the URL in your own SFSafariViewController or WebView
                    print("Survey URL: \(url)")
                }
            }
        }
    }
}
```

## Troubleshooting
- **User ID**: Ensure `configure(apiKey:user:)` is called before any other methods.
- **Delegates**: Set `delegate` and `rewardDelegate` to receive callbacks.
- **ATS**: If using `http` for local development, ensure your `Info.plist` allows arbitrary loads or configures exception domains.
