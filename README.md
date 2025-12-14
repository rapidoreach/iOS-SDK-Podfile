# RapidoReach iOS SDK

Lightweight rewarded survey offerwall SDK for iOS. Integrate to monetise your users with minimal effort and a native WebView experience.

## Installation (CocoaPods)

```ruby
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'RapidoReach', '~> 1.0.8'
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
        
        // Set delegates (rewardDelegate is only used when your app is configured for client-side rewards)
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

### Readiness and SDK-level errors

After `fetchAppUserID()` completes successfully, `RapidoReach.shared.isReady` becomes `true`.

If you want explicit callbacks for readiness/errors (in addition to `RapidoReachDelegate.didGetError`), set `sdkDelegate`:

```swift
extension AppDelegate: RapidoReachSDKDelegate {
  func onSDKReady() { print("RapidoReach ready") }
  func onSDKError(_ error: RapidoReachError) { print("RapidoReach SDK error: \(error)") }
}

RapidoReach.shared.sdkDelegate = self
```

### Customizing SDK options (navigation bar)

```swift
RapidoReach.shared.setNavigationBarText(for: "Earn Rewards")
RapidoReach.shared.setNavigationBarColor(for: "#211548")
RapidoReach.shared.setNavigationBarTextColor(for: "#FFFFFF")
```

### User identity

If your user logs in/out, update the user identifier and refresh SDK state:

```swift
RapidoReach.shared.setUserIdentifier("NEW_USER_ID")
RapidoReach.shared.fetchAppUserID()
```

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

Other placement helpers:
- `getPlacementDetails(tag:completion:)`
- `hasSurveys(tag:completion:)`
- `canShowSurvey(surveyId:tag:completion:)`

### Content lifecycle events (per placement)

If you want callbacks when content is shown/dismissed for a placement tag:

```swift
extension AppDelegate: RapidoReachContentDelegate {
  func onContentShown(forPlacement placement: String) {}
  func onContentDismissed(forPlacement placement: String) {}
}

RapidoReach.shared.contentDelegate = self
```

### User Attributes
Send user attributes for better survey targeting.

```swift
let attributes: [String: Any] = [
    "gender": "male",
    "age": 25,
    "zip": "90210"
]
RapidoReach.shared.sendUserAttributes(attributes, clearPrevious: false)
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

### Presenting content

Most apps should use:
- `presentOfferwall(from:title:customParameters:completion:)`

If you have a single-survey flow, you can also present the survey view:
- `presentSurvey(_:title:customParameters:completion:)`

### Quick Questions

```swift
RapidoReach.shared.hasQuickQuestions(tag: "default") { result in
  if case .success(let has) = result, has {
    RapidoReach.shared.fetchQuickQuestions(tag: "default") { payloadResult in
      if case .success(let payload) = payloadResult {
        // payload contains `quick_questions` with question objects (including `id`)
        let questions = payload["quick_questions"] as? [[String: Any]] ?? []
        let firstId = questions.first?["id"] as? String ?? ""
        guard !firstId.isEmpty else { return }

        RapidoReach.shared.answerQuickQuestion(id: firstId, placement: "default", answer: "yes") { _ in }
      }
    }
  }
}
```

### Rewards

For production reward attribution, use server-to-server callbacks whenever possible.
If your app is configured for client-side rewards, you can also refresh reward state from the client:

```swift
RapidoReach.shared.fetchRewards()
```

### Report abandon (optional)

If you want to report that a user abandoned the survey session:

```swift
RapidoReach.shared.reportAbandon()
```

### App Tracking Transparency (ATT)

If your app uses IDFA, request tracking permission in your app and include `NSUserTrackingUsageDescription` in `Info.plist`.
The SDK provides a helper via its default device info provider:

```swift
RapidoReachDeviceInfo().requestTrackingPermission()
```

### Debug logging

Forward SDK log lines into your app logging:

```swift
RapidoReachLogger.shared.level = .debug
RapidoReachLogger.shared.sink = { level, line in
  print(line)
}
```

### SwiftUI helper (optional)

If you use SwiftUI, you can use the built-in button:

```swift
RapidoReachOfferwallButton(title: "Surveys", placement: "default")
```

## Troubleshooting
- **User ID**: Ensure `configure(apiKey:user:)` is called before any other methods.
- **Delegates**: Set `delegate` and `rewardDelegate` to receive callbacks.
- **ATS**: If using `http` for local development, ensure your `Info.plist` allows arbitrary loads or configures exception domains.
