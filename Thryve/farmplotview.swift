import SwiftUI

// Farm Plot View
struct FarmPlotView: View {
    let plot: FarmPlot
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Brown circle for plot
                Circle()
                    .fill(plotColor)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.red : Color.clear, lineWidth: 3)
                    )
                
                // Show plant if planted
                if plot.status == .planted, let plant = plot.plant {
                    VStack {
                        // Plant visualization based on growth stage
                        ZStack {
                            switch plot.currentGrowthStage {
                            case .seed:
                                // Small seed
                                Circle()
                                    .fill(Color.brown.opacity(0.8))
                                    .frame(width: 10, height: 10)
                            case .sprout:
                                // Small sprout
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: 5, height: 15)
                                    Circle()
                                        .fill(Color.green.opacity(0.8))
                                        .frame(width: 12, height: 12)
                                }
                            case .growing:
                                // Growing plant
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: 8, height: 25)
                                    ForEach(0..<2) { _ in
                                        HStack {
                                            Circle()
                                                .fill(Color.green.opacity(0.8))
                                                .frame(width: 10, height: 10)
                                            Circle()
                                                .fill(Color.green.opacity(0.8))
                                                .frame(width: 10, height: 10)
                                        }
                                        .offset(x: 0, y: -5)
                                    }
                                }
                            case .mature:
                                // Mature plant with fruit/vegetable
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: 10, height: 25)
                                    Text(plant.emoji)
                                        .font(.system(size: 20))
                                }
                                .overlay(
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 10))
                                        .offset(x: 20, y: -15)
                                        .opacity(plot.isReadyToHarvest ? 1.0 : 0)
                                )
                            }
                        }
                        
                        // Water droplet if watered
                        if plot.isWatered {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.blue)
                                .offset(y: 5)
                        }
                    }
                    .offset(y: -10)
                } else if plot.status == .tilled {
                    // Show tilled soil lines
                    ForEach(0..<3) { i in
                        Rectangle()
                            .fill(Color.brown.opacity(0.5))
                            .frame(width: 30, height: 2)
                            .offset(y: CGFloat(i * 8 - 8))
                    }
                }
            }
        }
    }
    
    // Color based on plot status
    var plotColor: Color {
        switch plot.status {
        case .empty:
            return Color.brown
        case .tilled:
            return Color.brown.opacity(0.7)
        case .planted:
            return plot.isWatered ? Color.brown.opacity(0.8) : Color.brown.opacity(0.6)
        }
    }
}
