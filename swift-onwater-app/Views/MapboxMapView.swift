import SwiftUI
@_spi(Experimental) import MapboxMaps

struct MapboxMapView: UIViewRepresentable {
    @Binding var layerConfig: MapLayerConfig
    
    // Mapbox public token - Replace with your own from https://account.mapbox.com/
    static let mapboxToken = "pk.eyJ1Ijoib253YXRlcmxsYyIsImEiOiJja3poaWFjbnc0MjVrMm9tem5kenVqd3h3In0.2yMEyumU5erOQ6B5GadT5w"
    
    func makeUIView(context: Context) -> MapView {
        // Configure Mapbox access token
        MapboxOptions.accessToken = Self.mapboxToken
        
        // Initial camera position (Vermont)
        let cameraOptions = CameraOptions(
            center: CLLocationCoordinate2D(latitude: 44.5, longitude: -72.7),
            zoom: 9,
            bearing: 0,
            pitch: 45,
        )
        
        // Map initialization options
        let mapInitOptions = MapInitOptions(
            cameraOptions: cameraOptions,
            styleURI: .dark
        )
        
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Enable user location
        mapView.location.options.puckType = .puck2D()
        
        // Add terrain and layers when style loads
        mapView.mapboxMap.onStyleLoaded.observeNext { _ in
            self.setupTerrain(mapView: mapView)
            self.setupRiversLayer(mapView: mapView)
            self.setupWindLayer(mapView: mapView)
        }.store(in: &context.coordinator.cancelables)
        
        context.coordinator.mapView = mapView
        
        return mapView
    }
    
    func updateUIView(_ mapView: MapView, context: Context) {
        // Update layer visibility based on config
        updateLayerVisibility(mapView: mapView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: - Setup Methods
    
    private func setupTerrain(mapView: MapView) {
        // Add terrain source
        var demSource = RasterDemSource(id: "mapbox-dem")
        demSource.url = "mapbox://mapbox.mapbox-terrain-dem-v1"
        demSource.tileSize = 512
        demSource.maxzoom = 14
        
        do {
            try mapView.mapboxMap.addSource(demSource)
            
            // Enable 3D terrain
            var terrain = Terrain(sourceId: "mapbox-dem")
            terrain.exaggeration = .constant(1.5)
            try mapView.mapboxMap.setTerrain(terrain)
            
            print("✅ Terrain enabled")
        } catch {
            print("❌ Error setting up terrain: \(error)")
        }
    }
    
    private func setupRiversLayer(mapView: MapView) {
        // Add rivers vector source
        var riversSource = VectorSource(id: "rivers-source")
        riversSource.url = "mapbox://lman967.d0g758s3"
        
        do {
            try mapView.mapboxMap.addSource(riversSource)
            
            // Add rivers line layer
            var riversLayer = LineLayer(id: "rivers-layer", source: "rivers-source")
            riversLayer.sourceLayer = "testRiversSet-cr53z3"
            riversLayer.lineColor = .constant(StyleColor(.systemBlue))
            riversLayer.lineWidth = .expression(
                Exp(.interpolate) {
                    Exp(.linear)
                    Exp(.zoom)
                    6; 0.5
                    10; 1.5
                    14; 3.0
                }
            )
            riversLayer.lineOpacity = .constant(0.9)
            riversLayer.lineCap = .constant(.round)
            riversLayer.lineJoin = .constant(.round)
            
            try mapView.mapboxMap.addLayer(riversLayer)
            
            // Add rivers label layer
            var labelsLayer = SymbolLayer(id: "rivers-labels", source: "rivers-source")
            labelsLayer.sourceLayer = "testRiversSet-cr53z3"
            labelsLayer.minZoom = 10
            labelsLayer.textField = .expression(Exp(.get) { "gnis_name" })
            labelsLayer.textFont = .constant(["DIN Pro Italic", "Arial Unicode MS Regular"])
            labelsLayer.textSize = .expression(
                Exp(.interpolate) {
                    Exp(.linear)
                    Exp(.zoom)
                    10; 10
                    14; 13
                }
            )
            labelsLayer.symbolPlacement = .constant(.line)
            labelsLayer.textColor = .constant(StyleColor(UIColor(red: 0.23, green: 0.49, blue: 0.65, alpha: 1.0)))
            labelsLayer.textHaloColor = .constant(StyleColor(.white))
            labelsLayer.textHaloWidth = .constant(1.5)
            
            try mapView.mapboxMap.addLayer(labelsLayer)
            
            print("✅ Rivers layer added")
        } catch {
            print("❌ Error setting up rivers: \(error)")
        }
    }
    
    private func setupWindLayer(mapView: MapView) {
        // Add HRRR wind raster array source
        var windSource = RasterArraySource(id: "wind-source")
        windSource.url = "mapbox://onwaterllc.hrrr_wind_northeast"
        windSource.tileSize = 512
        windSource.minzoom = 4
        windSource.maxzoom = 8
        
        do {
            try mapView.mapboxMap.addSource(windSource)
            
            // Add animated wind particle layer
            var windLayer = RasterParticleLayer(id: "wind-layer", source: "wind-source")
            windLayer.sourceLayer = "wind10m"
            windLayer.rasterParticleArrayBand = .constant("1770854400")
            windLayer.rasterParticleCount = .constant(1024)
            windLayer.rasterParticleMaxSpeed = .constant(18)  // Data range: -9.6 to 17.4 m/s
            windLayer.rasterParticleSpeedFactor = .constant(0.4)
            windLayer.rasterParticleResetRateFactor = .constant(0.8)
            windLayer.rasterParticleFadeOpacityFactor = .constant(0.9)
            windLayer.minZoom = 4
            windLayer.maxZoom = 22
            windLayer.rasterParticleColor = .expression(
                Exp(.interpolate) {
                    Exp(.linear)
                    Exp(.rasterParticleSpeed)
                    0; UIColor.systemCyan
                    5; UIColor.systemGreen
                    10; UIColor.systemYellow
                    14; UIColor.systemOrange
                    18; UIColor.systemRed
                }
            )
            
            try mapView.mapboxMap.addLayer(windLayer)
            print("✅ Wind particle layer added")
        } catch {
            print("❌ Error setting up wind layer: \(error)")
        }
    }
    
    private func updateLayerVisibility(mapView: MapView) {
        do {
            // Toggle rivers layer
            try mapView.mapboxMap.updateLayer(withId: "rivers-layer", type: LineLayer.self) { layer in
                layer.visibility = .constant(layerConfig.showRivers ? .visible : .none)
            }
            try mapView.mapboxMap.updateLayer(withId: "rivers-labels", type: SymbolLayer.self) { layer in
                layer.visibility = .constant(layerConfig.showRivers ? .visible : .none)
            }
            // Toggle wind layer
            try mapView.mapboxMap.updateLayer(withId: "wind-layer", type: RasterParticleLayer.self) { layer in
                layer.visibility = .constant(layerConfig.showWind ? .visible : .none)
            }
        } catch {
            // Layer might not exist yet
        }
    }
    
    // MARK: - Coordinator
    
    class Coordinator {
        var mapView: MapView?
        var cancelables = Set<AnyCancelable>()
    }
}
