# onWater iOS Mapbox App

A native Swift/SwiftUI iOS app with Mapbox Maps SDK, 3D terrain, and custom vector layers.

## Requirements

- macOS with Xcode 15+
- iOS 15.0+ deployment target
- Mapbox account (token included for testing)

## Quick Setup (5 minutes)

### 1. Clone the repo
```bash
git clone https://github.com/liampaus967-clawdbot/onwater-ios-mapbox.git
cd onwater-ios-mapbox
```

### 2. Create Xcode Project

1. Open **Xcode** → `File` → `New` → `Project`
2. Select **iOS** → **App** → Next
3. Configure:
   - Product Name: `onWaterMaps`
   - Team: Your team (or None for now)
   - Organization Identifier: `com.onwater`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Uncheck "Include Tests"
4. Save it **inside** this cloned repo folder (replace the placeholder)

### 3. Add Mapbox SDK via Swift Package Manager

1. In Xcode: `File` → `Add Package Dependencies...`
2. Enter URL: `https://github.com/mapbox/mapbox-maps-ios.git`
3. Select version: **11.0.0** or later
4. Click `Add Package`
5. Check `MapboxMaps` → `Add to Target: onWaterMaps`

### 4. Replace Default Files

Delete the auto-generated files and use ours:

1. Delete `ContentView.swift` from the project
2. Drag these folders into your Xcode project navigator:
   - `onWaterMaps/App/`
   - `onWaterMaps/Views/`
   - `onWaterMaps/Models/`
3. When prompted, select:
   - ✅ Copy items if needed
   - ✅ Create groups
   - Target: onWaterMaps

### 5. Configure Mapbox Token (Optional)

The app includes a working public token. To use your own:

Edit `MapboxMapView.swift`:
```swift
static let mapboxToken = "pk.YOUR_TOKEN_HERE"
```

### 6. Build & Run

1. Select a simulator (iPhone 15 Pro recommended)
2. Press `Cmd + R`
3. 🎉 You should see the map!

---

## Project Structure

```
onWaterMaps/
├── App/
│   └── onWaterMapsApp.swift    # App entry point
├── Views/
│   ├── ContentView.swift       # Main view with map + controls
│   ├── MapboxMapView.swift     # Mapbox UIViewRepresentable wrapper
│   └── LayerControlView.swift  # Layer toggle panel
├── Models/
│   └── MapLayerConfig.swift    # Layer visibility state
└── Info.plist                  # App configuration
```

## Features

- ✅ Mapbox base map (Outdoors style)
- ✅ 3D terrain with exaggeration
- ✅ Rivers vector layer (your tileset)
- ✅ River labels (gnis_name)
- ✅ Layer toggle controls
- ✅ User location puck
- 🔲 Custom basemap styles
- 🔲 Offline maps
- 🔲 Search

## Layers Included

| Layer | Source | Status |
|-------|--------|--------|
| Rivers | `mapbox://lman967.d0g758s3` | ✅ Working |
| Rivers Labels | gnis_name field | ✅ Working |
| 3D Terrain | mapbox-terrain-dem-v1 | ✅ Working |

## Customization

### Change Starting Location

In `MapboxMapView.swift`:
```swift
let cameraOptions = CameraOptions(
    center: CLLocationCoordinate2D(latitude: 44.5, longitude: -72.7),
    zoom: 9,
    pitch: 45,
    bearing: -10
)
```

### Add More Layers

Add new layers in `setupRiversLayer()` or create new setup methods.

### Change Base Style

```swift
let mapInitOptions = MapInitOptions(
    cameraOptions: cameraOptions,
    styleURI: .outdoors  // or .streets, .satellite, .dark, etc.
)
```

## Troubleshooting

**"No such module 'MapboxMaps'"**
→ Make sure you added the package (Step 3) and it finished downloading

**Map is blank**
→ Check the Mapbox token is valid
→ Check console for error messages

**Build fails with signing error**
→ Select your team in Project Settings → Signing & Capabilities

---

## Mapbox Token

You'll need your own Mapbox public token from https://account.mapbox.com/

Add it in `MapboxMapView.swift`:
```swift
static let mapboxToken = "pk.your_token_here"
```

---

Built by Sandy 🐕 for onWater
