import SwiftUI

struct ContentView: View {
    @State private var showLayerControls = false
    @State private var layerConfig = MapLayerConfig()
    
    var body: some View {
        ZStack {
            // Main Map View
            MapboxMapView(layerConfig: $layerConfig)
                .ignoresSafeArea()
            
            // Layer Control Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            showLayerControls.toggle()
                        }
                    }) {
                        Image(systemName: "square.3.layers.3d")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
            
            // Layer Controls Panel
            if showLayerControls {
                LayerControlView(
                    layerConfig: $layerConfig,
                    isPresented: $showLayerControls
                )
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    ContentView()
}
