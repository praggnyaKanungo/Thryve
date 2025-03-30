import SwiftUI

// Main Farm View
struct FarmMapView: View {
    @ObservedObject var farmManager = FarmMapManager.shared
    @ObservedObject var inventoryManager = InventoryManager.shared
    @ObservedObject var coinsManager = CoinsManager.shared
    @ObservedObject var calendar = GameCalendar.shared
    @ObservedObject var timerManager = GameTimerManager.shared
    
    // Add a state variable to track harvest count
    @State private var harvestCount = 0
    
    @State private var showingInventory = false
    @State private var showingPlantSelection = false
    @State private var showingActionError = false
    @State private var actionErrorMessage = ""
    @State private var navigateToShopping = false
    @State private var showingDonationInfo = false
    
    var body: some View {
        ZStack {
            // Background based on season
            seasonBackground
            
            VStack {
                // Top bar with game info
                HStack {
                    // Back/Shop button
                    Button(action: {
                        navigateToShopping = true
                    }) {
                        HStack {
                            Image(systemName: "cart")
                            Text("Shop")
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    // Harvest count display
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                        
                        Text("Harvests: \(harvestCount)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    // Donation progress
                    Button(action: {
                        showingDonationInfo = true
                    }) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            
                            Text("\(farmManager.totalSuccessfulHarvests % 10)/10")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    // Timer display (only show when timer is running)
                    if timerManager.isTimerRunning {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.white)
                            
                            Text("Next Day: \(timerManager.formattedTimeRemaining)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(15)
                        .padding(.vertical, 10)
                    }
                    
                    Spacer()
                    
                    // Calendar info
                    HStack {
                        VStack(alignment: .trailing) {
                            HStack {
                                Image(systemName: calendar.currentSeason.icon)
                                    .foregroundColor(calendar.currentSeason.color)
                                Text(calendar.currentSeason.rawValue.capitalized)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Image(systemName: calendar.currentWeather.icon)
                                    .foregroundColor(calendar.currentWeather.color)
                                Text("Day \(calendar.currentDay)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    // Coins display
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.yellow)
                        
                        Text("\(coinsManager.totalCoins)")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Farm grid
                VStack(spacing: 30) {
                    ForEach(0..<farmManager.rows, id: \.self) { row in
                        HStack(spacing: 40) {
                            ForEach(0..<farmManager.columns, id: \.self) { column in
                                let index = row * farmManager.columns + column
                                if index < farmManager.plots.count {
                                    FarmPlotView(
                                        plot: farmManager.plots[index],
                                        isSelected: farmManager.selectedPlotIndex == index,
                                        action: {
                                            farmManager.selectedPlotIndex = index
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
                .padding()
                
                // Weather effect info
                HStack {
                    Image(systemName: calendar.currentWeather.icon)
                        .foregroundColor(calendar.currentWeather.color)
                    
                    Text("\(calendar.currentWeather.rawValue.capitalized) weather: \(Int(calendar.currentWeather.growthMultiplier * 100))% growth")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Image(systemName: calendar.currentSeason.icon)
                        .foregroundColor(calendar.currentSeason.color)
                    
                    Text("\(calendar.currentSeason.rawValue.capitalized) season: \(Int(calendar.currentSeason.growthMultiplier * 100))% growth")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                
                // Bottom action bar
                HStack(spacing: 15) {
                    // Till button
                    Button(action: {
                        if let index = farmManager.selectedPlotIndex {
                            let success = farmManager.tillPlot(plotIndex: index)
                            if !success {
                                actionErrorMessage = "Cannot till this plot right now"
                                showingActionError = true
                            }
                        } else {
                            actionErrorMessage = "Select a plot first"
                            showingActionError = true
                        }
                    }) {
                        VStack {
                            Image(systemName: "leaf.fill")
                            Text("Till")
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.brown)
                        .cornerRadius(10)
                    }
                    
                    // Plant button
                    Button(action: {
                        if let index = farmManager.selectedPlotIndex {
                            if farmManager.plots[index].status == .tilled {
                                showingPlantSelection = true
                            } else {
                                actionErrorMessage = "Till the plot before planting"
                                showingActionError = true
                            }
                        } else {
                            actionErrorMessage = "Select a plot first"
                            showingActionError = true
                        }
                    }) {
                        VStack {
                            Image(systemName: "leaf.arrow.circlepath")
                            Text("Plant")
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    
                    // Water button
                    Button(action: {
                        if let index = farmManager.selectedPlotIndex {
                            let success = farmManager.waterPlot(plotIndex: index)
                            if !success {
                                actionErrorMessage = "Cannot water this plot right now"
                                showingActionError = true
                            }
                        } else {
                            actionErrorMessage = "Select a plot first"
                            showingActionError = true
                        }
                    }) {
                        VStack {
                            Image(systemName: "drop.fill")
                            Text("Water")
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
                    // Harvest button
                    Button(action: {
                        if let index = farmManager.selectedPlotIndex {
                            let success = farmManager.harvestPlot(plotIndex: index)
                            if success {
                                // Increment harvest count when successfully harvested
                                harvestCount += 1
                                // Save harvest count to UserDefaults
                                UserDefaults.standard.set(harvestCount, forKey: "playerHarvestCount")
                            } else {
                                actionErrorMessage = "Not ready to harvest yet"
                                showingActionError = true
                            }
                        } else {
                            actionErrorMessage = "Select a plot first"
                            showingActionError = true
                        }
                    }) {
                        VStack {
                            Image(systemName: "scissors")
                            Text("Harvest")
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.orange)
                        .cornerRadius(10)
                    }
                    
                    // Next Day button - Only show if auto timer is not running
                    if !timerManager.isTimerRunning {
                        Button(action: {
                            farmManager.advanceDay()
                        }) {
                            VStack {
                                Image(systemName: "calendar")
                                Text("Next Day")
                            }
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.purple)
                            .cornerRadius(10)
                        }
                    } else {
                        // Show day counter when timer is running
                        VStack {
                            Image(systemName: "calendar")
                            Text("Day \(calendar.currentDay)")
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(15)
                .padding()
            }
            
            // Navigation link to shopping
            NavigationLink("", destination: ShoppingView(), isActive: $navigateToShopping)
                .hidden()
        }
        .navigationTitle("Your Farm")
        .sheet(isPresented: $showingInventory) {
            InventoryView()
        }
        .sheet(isPresented: $showingPlantSelection) {
            PlantSelectionView { plant in
                if let index = farmManager.selectedPlotIndex {
                    let success = farmManager.plantInPlot(plotIndex: index, plant: plant)
                    if !success {
                        actionErrorMessage = "Could not plant here"
                        showingActionError = true
                    }
                }
                showingPlantSelection = false
            }
        }
        .alert(isPresented: $showingActionError) {
            Alert(
                title: Text("Action Failed"),
                message: Text(actionErrorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $showingDonationInfo) {
            DonationInfoView()
        }
        .onAppear {
            // Load saved harvest count from UserDefaults
            harvestCount = UserDefaults.standard.integer(forKey: "playerHarvestCount")
            
            // Resume timer if it was running when view appeared
            if timerManager.isTimerRunning {
                timerManager.resumeTimer()
            }
        }
        .onDisappear {
            // Pause timer when view disappears
            timerManager.pauseTimer()
        }
    }
    
    // Background based on current season and weather
    var seasonBackground: some View {
        ZStack {
            // Base background image
            Image("crop") // Make sure this image exists in your Assets
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            // Season overlay
            Rectangle()
                .fill(seasonColor)
                .blendMode(.overlay)
                .edgesIgnoringSafeArea(.all)
            
            // Weather effects
            weatherEffects
        }
    }
    
    // Season-specific color overlay
    var seasonColor: Color {
        switch calendar.currentSeason {
        case .spring:
            return Color.green.opacity(0.2)
        case .summer:
            return Color.yellow.opacity(0.2)
        case .fall:
            return Color.orange.opacity(0.3)
        case .winter:
            return Color.blue.opacity(0.3)
        }
    }
    
    // Weather effects
    var weatherEffects: some View {
        Group {
            switch calendar.currentWeather {
            case .sunny:
                EmptyView()
            case .hot:
                HotEffect()
            case .rainy:
                RainEffect()
            case .storm:
                StormEffect()
            }
        }
    }
}
