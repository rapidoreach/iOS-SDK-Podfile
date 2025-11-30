# RapidoReach SDK + Backend Testing Checklist

End-to-end steps for the current SDK + CBAppSDKsMicroservice using the proxy to `www.rapidoreach.com` `getallsurveys-api` (no dist JS imports needed).

## Backend (CBAppSDKsMicroservice)
1) Install & build:
   ```bash
   cd /Users/vikashkumar/Desktop/cds_projects/CBAppSDKsMicroservice
   npm install
   npm run build
   ```
2) Run with the desired upstream backend:
   ```bash
   # defaults: RRB_BACKEND_BASE=https://www.rapidoreach.com, SURVEY_PROXY_TIMEOUT_MS=8000
   PORT=8083 npm start
   ```
   - Override `RRB_BACKEND_BASE` to hit staging/dev if needed.
3) Smoke test (replace values):
   - Register user: `curl "http://localhost:8083/api/sdk/v1/appusers?gps_id=...&api_key=...&user_id=..."`
   - Attributes (reserved prefix `tapresearch_` rejected):  
     `curl -X POST http://localhost:8083/api/sdk/v2/user_attributes -H "Content-Type: application/json" -d '{"api_key":"...","sdk_user_id":"<id>","attributes":{"tier":"gold"},"clear_previous":false}'`
   - Placement info:  
     `curl "http://localhost:8083/api/sdk/v2/placements/default/details?api_key=...&sdk_user_id=<id>"`
     `curl "http://localhost:8083/api/sdk/v2/placements/default/can_show?api_key=...&sdk_user_id=<id>"`
   - Survey list (proxied to backend `getallsurveys-api`):  
     `curl "http://localhost:8083/api/sdk/v2/placements/default/surveys?api_key=...&sdk_user_id=<id>"`
   - Survey show-by-id:  
     `curl -X POST "http://localhost:8083/api/sdk/v2/placements/default/surveys/<surveyId>/show" -H "Content-Type: application/json" -d '{"api_key":"...","sdk_user_id":"<id>"}'`
     - Optional `custom_params` payloads are accepted; they are base64-encoded into the entry link.
   - Quick Questions (capability stub):  
     `curl "http://localhost:8083/api/sdk/v2/placements/default/quick_questions?api_key=...&sdk_user_id=<id>"` should return `enabled:false` / `reason: NOT_ENABLED` until backend support exists.
   - Rewards:  
     `curl "http://localhost:8083/api/sdk/v2/appusers/<id>/appuser_rewards?api_key=...&enc=<md5(url_without_enc+rewardHashSalt)>"`
     - Response includes legacy totals and `rewards` array (`transactionIdentifier`, `rewardAmount`, etc.).

## iOS SDK (Test app)
1) Base URL: in DEBUG we default to `http://localhost:8083`; override if microservice runs elsewhere:
   ```swift
   RapidoReach.shared.updateBackend(baseURL: URL(string: "http://localhost:8083")!)
   ```
2) Configure and register:
   ```swift
   RapidoReach.shared.configure(apiKey: "<API_KEY>", user: "<USER_ID>")
   RapidoReach.shared.sdkDelegate = self
   RapidoReach.shared.fetchAppUserID() // registers user + fetches rewards
   ```
3) Send attributes:
   ```swift
   RapidoReach.shared.sendUserAttributes(["tier": "gold"], clearPrevious: false)
   ```
4) Placement/survey checks:
   ```swift
   RapidoReach.shared.getPlacementDetails(tag: "default") { result in ... }
   RapidoReach.shared.hasSurveys(forPlacement: "default") { canShow, _ in ... }
   RapidoReach.shared.listSurveys(forPlacement: "default") { surveys, _ in ... }
   ```
5) Show content/survey:
   ```swift
   RapidoReach.shared.presentOfferwall(from: someViewController, title: "Surveys")
   if let surveyId = surveys.first?["survey_identifier"] as? String {
       RapidoReach.shared.showSurvey(id: surveyId, placement: "default", presenter: someViewController, title: "Survey")
   }
   ```
6) Rewards:
   - After backend issues a reward, call `fetchRewards()`; observe `rewardDelegate.onRewards(...)` payload.
7) Quick Questions (currently disabled by backend):  
   ```swift
   RapidoReach.shared.hasQuickQuestions(tag: "default") { result in /* expect failure with NOT_SUPPORTED */ }
   ```

## Hash for rewards (enc)
- Compute `enc` as `md5(<full rewards URL without &enc> + rewardHashSalt)`. Default salt: `12fb172e94cfcb20dd65c315336b919f` unless overridden.

## GitHub Workflows (build + pod publish)
- **Build RapidoReach XCFramework** (`.github/workflows/ios-release.yml`): tag push `v*` or manual dispatch. Runs `pod install`, `scripts/build_xcframework.sh`, uploads zip, and (optionally) creates a Release when `release=true`.
- **Publish CocoaPod** (`.github/workflows/pod-publish.yml`): manual dispatch. Inputs: `podspec` (default `RapidoReach.podspec`), `allow_warnings` (default true). Requires secret `COCOAPODS_TRUNK_TOKEN`. Runs `pod lib lint` then `pod trunk push`.

## Pod publishing prep (local)
- Run the local lint script before pushing a pod:
  ```bash
  cd /Users/vikashkumar/Documents/cds_mobile_projects/cbiossdk
  scripts/test_pod.sh RapidoReach.podspec   # add --no-allow-warnings to be strict
  ```
- Keep the podspec version bumped (e.g., 1.0.3) before running lint/push.
- CocoaPods trunk credentials:
  - Register (one-time): `pod trunk register kvikash766@gmail.com 'Vikash Kumar' --description='Rapidoreach ios pod'` then verify via email.
  - Token is stored in `~/.cocoapods/trunk/config.json`; view with `pod trunk me`.
  - For CI/workflow: set secret `COCOAPODS_TRUNK_TOKEN` to that token. Locally, the token is read automatically from the config.
