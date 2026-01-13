# Native Birds (iOS) — SwiftUI + Clean Architecture

**Native Birds** is an iOS app that discovers **nearby birds** using the device’s **current GPS location**, displays them in a **SwiftUI** experience, and lets users **listen to bird recordings**. The project follows **Clean Architecture / Clean Code** with a clear separation of UI, Presentation, Domain, Data, and External Systems. :contentReference[oaicite:0]{index=0}

---

## Design Proposal (UI)

> Add your design proposal image here (Figma export / screenshot).

![Design Proposal](docs/proposal.png)

> If you want to include the architecture diagram image shown in this repository, place it under `docs/architecture.png` and reference it:
>
> ![Architecture Diagram](docs/diagram.png)

---

## Architecture Overview (Clean Architecture)

The app is structured in layers:

- **UI Layer (SwiftUI)**
  - Navigation: `AppRouter`, `AppRouterView`
  - Views: `SplashView`, `BirdsListView`, `BirdDetailView`
  - Animations: **SpriteKit** (see “Animations” below)
  - Design System: spacing, typography, theme, reusable UI components :contentReference[oaicite:1]{index=1}

- **Presentation Layer**
  - ViewModels (e.g., `SplashViewModel`, `BirdsListViewModel`, `BirdDetailViewModel`) injected via `DIContainer` :contentReference[oaicite:2]{index=2}

- **Domain Layer**
  - Use Cases:
    - `FetchNearbyBirdsUseCase`
    - `FetchBirdRecordingUseCase` :contentReference[oaicite:3]{index=3}
  - Entities:
    - `Bird`, `BirdRecording`, `PagedResult`, `BirdsPage` :contentReference[oaicite:4]{index=4}
  - Interfaces (Protocols):
    - `BirdsRepositoryProtocol`, `XenoCantoRepositoryProtocol`, `RemoteConfigProtocol`, `LocationServiceProtocol`, cache protocols :contentReference[oaicite:5]{index=5}

- **Data Layer**
  - Repositories:
    - iNaturalist: `BirdsRepository`
    - Xeno-canto: `XenoCantoRepository`
    - Remote Config: `RemoteConfigRepository` :contentReference[oaicite:6]{index=6}
  - Infrastructure:
    - Network: `URLSessionNetworkClient`
    - Cache: `DiskTTLCache`, `BirdImageCache`, `BirdAudioCache` :contentReference[oaicite:7]{index=7}
    - Audio download: `AudioDownloadService` :contentReference[oaicite:8]{index=8}

- **External Systems**
  - **iNaturalist API** for nearby observations (birds + photos) :contentReference[oaicite:9]{index=9}
  - **Xeno-canto API** for top bird recordings :contentReference[oaicite:10]{index=10}
  - **Firebase Remote Config** to securely fetch API keys at runtime :contentReference[oaicite:11]{index=11}

---

## Key Features

### 1) Nearby birds using GPS current location
The app requests location permission and retrieves the **current coordinates** using `CoreLocation` via `LocationService`. :contentReference[oaicite:12]{index=12}

### 2) API keys from Firebase Remote Config
API keys are not hardcoded. They are fetched from **Firebase Remote Config** and cached in memory inside `RemoteConfigRepository`. :contentReference[oaicite:13]{index=13}

Remote Config keys used:
- `inat_bearer_token`
- `xeno_canto_key` :contentReference[oaicite:14]{index=14}

### 3) 15-day cache for images and audio
The app caches both images and audio on disk with a **TTL of 15 days**:
- `BirdImageCache` → `DiskTTLCache(folderName: "BirdImages", ttl: 60*60*24*15)`
- `BirdAudioCache` → `DiskTTLCache(folderName: "BirdAudio", ttl: 60*60*24*15)` :contentReference[oaicite:15]{index=15}

### 4) SpriteKit animations (bird flight)
For rich loading / placeholder experiences, the app uses **SpriteKit** with a sprite sheet:
- `BirdFlightScene` + `BirdFlightView`
- Loaded via `SpriteView` in SwiftUI :contentReference[oaicite:16]{index=16}

### 5) Design System implemented
Centralized tokens for:
- Colors (`BirdTheme`)
- Typography (`BirdTypography`)
- Spacing (`BirdSpacing`)
- Reusable components (`BirdButton`, `BirdLabel`, etc.) :contentReference[oaicite:17]{index=17}

---

## Data Flow (High-level)

1. **Splash**
   - Firebase is configured at app start (`FirebaseApp.configure()`).
   - Remote Config activates to fetch keys. :contentReference[oaicite:18]{index=18}

2. **Bird List**
   - Location permission is requested; current coordinates are retrieved.
   - `FetchNearbyBirdsUseCase` calls `BirdsRepository` (iNaturalist). :contentReference[oaicite:19]{index=19}

3. **Bird Detail**
   - `FetchBirdRecordingUseCase` normalizes scientific name to **genus + species** and calls Xeno-canto.
   - Audio is downloaded (if needed) and cached; playback uses `AVPlayer`. 

---

## Project Setup

### Requirements
- Xcode (latest stable)
- iOS 17+ (recommended)
- Swift Concurrency (async/await)
- Firebase (Core + Remote Config)

### Firebase Configuration
1. Add your `GoogleService-Info.plist` to the project.
2. Ensure Firebase is initialized in the app entry point (`FirebaseApp.configure()`). :contentReference[oaicite:21]{index=21}
3. Configure Remote Config parameters:
   - `inat_bearer_token`
   - `xeno_canto_key` :contentReference[oaicite:22]{index=22}

### Location Permissions
Add this to `Info.plist`:
- `NSLocationWhenInUseUsageDescription` (explain why location is required)

---

## Testing & Quality

- **Architecture:** Clean Architecture with protocol-driven boundaries (testable use cases / repositories). :contentReference[oaicite:23]{index=23}
- **Coverage:** 70% (project target / current status to be maintained and improved).

> Tip: add a badge once you have CI publishing coverage.
>
> Example:
> `![Coverage](https://img.shields.io/badge/coverage-70%25-brightgreen)`

---

## Repository Structure (suggested)

