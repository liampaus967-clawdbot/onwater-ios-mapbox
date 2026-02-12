import SwiftUI

struct LayerControlView: View {
    @Binding var layerConfig: MapLayerConfig
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Map Layers")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            Divider()
            
            // Layer Toggles
            ScrollView {
                VStack(spacing: 0) {
                    LayerToggleRow(
                        icon: "water.waves",
                        title: "Rivers",
                        subtitle: "NHD flowlines with labels",
                        isOn: $layerConfig.showRivers,
                        color: .blue
                    )
                    
                    Divider().padding(.leading, 56)
                    
                    LayerToggleRow(
                        icon: "mountain.2",
                        title: "Terrain",
                        subtitle: "3D elevation",
                        isOn: $layerConfig.showTerrain,
                        color: .brown
                    )
                    
                    Divider().padding(.leading, 56)
                    
                    LayerToggleRow(
                        icon: "leaf",
                        title: "Public Lands",
                        subtitle: "Parks, forests, BLM",
                        isOn: $layerConfig.showPublicLands,
                        color: .green
                    )
                    
                    Divider().padding(.leading, 56)
                    
                    LayerToggleRow(
                        icon: "map",
                        title: "Contours",
                        subtitle: "Elevation lines",
                        isOn: $layerConfig.showContours,
                        color: .orange
                    )
                    
                    Divider().padding(.leading, 56)
                    
                    LayerToggleRow(
                        icon: "wind",
                        title: "Wind",
                        subtitle: "Animated HRRR wind particles",
                        isOn: $layerConfig.showWind,
                        color: .cyan
                    )
                }
            }
        }
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
}

struct LayerToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isOn.toggle()
            }
        }
    }
}

#Preview {
    LayerControlView(
        layerConfig: .constant(MapLayerConfig()),
        isPresented: .constant(true)
    )
}
