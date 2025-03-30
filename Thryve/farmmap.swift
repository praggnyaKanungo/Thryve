import SwiftUI

// FarmMap manager class to track and manage the farm plots
class FarmMapManager: ObservableObject {
    // Singleton instance for app-wide access
    static let shared = FarmMapManager()
    
    // Number of plots in the farm
    var rows = 3
    var columns = 4
    var totalPlots = 12
    
    // Farm plots array
    @Published var plots: [FarmPlot] = [] {
        didSet {
            saveFarmData()
        }
    }
    
    // Currently selected plot
    @Published var selectedPlotIndex: Int?
    
    // Session identifier to track different game sessions
    private var currentSessionId: String = ""
    
    // Initialize with no farm data
    private init() {
        // No loading of farm data on initial startup
        initializeEmptyFarm()
    }
    
    // Initialize farm with empty plots
    private func initializeEmptyFarm() {
        plots.removeAll()
        for i in 0..<totalPlots {
            plots.append(FarmPlot(id: i))
        }
        selectedPlotIndex = nil
    }
    
    // Setup farm with selected region and size
    func setupFarm(regionId: String, rows: Int, columns: Int) {
        // Create a new session ID
        let newSessionId = "\(regionId)_\(rows)x\(columns)_\(UUID().uuidString)"
        
        // If session changed, clear the farm
        if currentSessionId != newSessionId {
            // Update farm dimensions
            self.rows = rows
            self.columns = columns
            self.totalPlots = rows * columns
            
            // Clear existing plots
            resetFarm()
            
            // Save new session ID
            currentSessionId = newSessionId
            UserDefaults.standard.set(currentSessionId, forKey: "currentFarmSession")
        }
        
        // Try to load saved data for this specific session
        loadFarmData()
        
        // If no saved data for this session, create empty plots
        if plots.isEmpty || plots.count != totalPlots {
            initializeEmptyFarm()
        }
    }
    
    // Save farm data to UserDefaults with session identifier
    private func saveFarmData() {
        guard !currentSessionId.isEmpty else { return }
        
        if let encoded = try? JSONEncoder().encode(plots) {
            UserDefaults.standard.set(encoded, forKey: "farmPlots_\(currentSessionId)")
        }
    }
    
    // Load farm data from UserDefaults for current session
    private func loadFarmData() {
        guard !currentSessionId.isEmpty else { return }
        
        if let savedFarmData = UserDefaults.standard.data(forKey: "farmPlots_\(currentSessionId)"),
           let decodedFarmData = try? JSONDecoder().decode([FarmPlot].self, from: savedFarmData) {
            plots = decodedFarmData
        }
    }
    
    // Plant an item in a plot
    func plantInPlot(plotIndex: Int, plant: Plant) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        let plot = plots[plotIndex]
        
        // Check if plot is available
        if plot.status == .empty || plot.status == .tilled {
            // Get the item from inventory
            let inventory = InventoryManager.shared
            
            if inventory.hasItem(plantId: plant.id) {
                // Remove from inventory
                let success = inventory.removeItem(plantId: plant.id, quantity: 1)
                
                if success {
                    // Update plot with planted item
                    plots[plotIndex].plantCrop(plant: plant)
                    return true
                }
            }
        }
        
        return false
    }
    
    // Till a plot to prepare for planting
    func tillPlot(plotIndex: Int) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        if plots[plotIndex].status == .empty {
            plots[plotIndex].status = .tilled
            return true
        }
        
        return false
    }
    
    // Water a planted plot
    func waterPlot(plotIndex: Int) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        if plots[plotIndex].status == .planted && !plots[plotIndex].isWatered {
            plots[plotIndex].isWatered = true
            return true
        }
        
        return false
    }
    
    // Harvest a plot when ready
    func harvestPlot(plotIndex: Int) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        let plot = plots[plotIndex]
        
        if plot.status == .planted && plot.isReadyToHarvest {
            // Get coins for harvesting
            if let plant = plot.plant {
                CoinsManager.shared.addCoins(plant.harvestValue, reason: "Harvested \(plant.name)")
            }
            
            // Reset plot to tilled state
            plots[plotIndex].status = .tilled
            plots[plotIndex].plant = nil
            plots[plotIndex].plantedDate = nil
            plots[plotIndex].isWatered = false
            
            return true
        }
        
        return false
    }
    
    // Clear a plot
    func clearPlot(plotIndex: Int) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        if plots[plotIndex].status != .empty {
            plots[plotIndex].status = .empty
            plots[plotIndex].plant = nil
            plots[plotIndex].plantedDate = nil
            plots[plotIndex].isWatered = false
            return true
        }
        
        return false
    }
    
    // Advance time for all plots (e.g. for a "next day" feature)
    func advanceDay() {
        for i in 0..<plots.count {
            // Grow plants that have been watered
            if plots[i].status == .planted && plots[i].isWatered {
                plots[i].growthProgress += 1.0 / Double(plots[i].plant?.growthTime ?? 1)
                plots[i].isWatered = false
            }
        }
    }
    
    // Reset farm (for testing/reset)
    func resetFarm() {
        initializeEmptyFarm()
    }
    
    // Method to call when starting a new game
    func startNewGame() {
        // Clear the current session ID
        currentSessionId = ""
        UserDefaults.standard.removeObject(forKey: "currentFarmSession")
        
        // Reset the farm
        resetFarm()
    }
}

// Plot status enum
enum PlotStatus: String, Codable {
    case empty
    case tilled
    case planted
}

// Farm plot model
struct FarmPlot: Codable, Identifiable {
    let id: Int
    var status: PlotStatus = .empty
    var plant: Plant?
    var plantedDate: Date?
    var isWatered: Bool = false
    var growthProgress: Double = 0
    
    // Plant a crop in this plot
    mutating func plantCrop(plant: Plant) {
        self.plant = plant
        self.status = .planted
        self.plantedDate = Date()
        self.growthProgress = 0
    }
    
    // Check if the crop is ready to harvest
    var isReadyToHarvest: Bool {
        return status == .planted && growthProgress >= 1.0
    }
}

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
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.red : Color.clear, lineWidth: 3)
                    )
                
                // Show plant if planted
                if plot.status == .planted, let plant = plot.plant {
                    VStack {
                        // Plant visualization
                        ZStack {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 10, height: 20 * plot.growthProgress)
                                .cornerRadius(2)
                            
                            Text(plant.placeholder)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                        
                        // Water droplet if watered
                        if plot.isWatered {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.blue)
                        }
                    }
                    .offset(y: -10)
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

// Main FarmMap View
struct FarmMapView: View {
    @ObservedObject var farmManager = FarmMapManager.shared
    @ObservedObject var inventoryManager = InventoryManager.shared
    @ObservedObject var coinsManager = CoinsManager.shared
    
    @State private var showingInventory = false
    @State private var showingPlantSelection = false
    @State private var showingActionError = false
    @State private var actionErrorMessage = ""
    @State private var navigateToShopping = false
    
    var body: some View {
        ZStack {
            // Background farm image - corrected name to "crop" as specified
            Image("crop") // This is the correct image name in Assets
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Top bar with coins
                HStack {
                    // Inventory button
                    Button(action: {
                        showingInventory = true
                    }) {
                        HStack {
                            Image(systemName: "leaf.arrow.triangle.circlepath")
                            Text("Inventory")
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    // Coins display
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.yellow)
                        
                        Text("\(coinsManager.totalCoins)")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                }
                .padding()
                
                Spacer()
                
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
                
                Spacer()
                
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
                            if !success {
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
                    
                    // Next Day button
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
            PlantSelectionView { plant in
                if let index = farmManager.selectedPlotIndex {
                    let success = farmManager.plantInPlot(plotIndex: index, plant: plant)
                    if !success {
                        actionErrorMessage = "Could not plant here"
                        showingActionError = true
                    }
                }
                showingInventory = false
            }
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
    }
}

// Plant selection view for choosing what to plant
struct PlantSelectionView: View {
    @ObservedObject var inventoryManager = InventoryManager.shared
    @State private var navigateToShopping = false
    let onPlantSelected: (Plant) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                if inventoryManager.items.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.gray)
                        
                        Text("Your inventory is empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Visit the shop to buy seeds and plants")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            navigateToShopping = true
                        }) {
                            Text("Go Shopping")
                                .fontWeight(.semibold)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        // Hidden navigation link
                        NavigationLink("", destination: ShoppingView(), isActive: $navigateToShopping)
                            .hidden()
                    }
                } else {
                    List {
                        ForEach(inventoryManager.items) { item in
                            Button(action: {
                                onPlantSelected(item.plant)
                            }) {
                                HStack {
                                    // Plant icon
                                    ZStack {
                                        Circle()
                                            .fill(Color.green.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                        
                                        Text(item.plant.placeholder)
                                            .font(.headline)
                                            .foregroundColor(.green)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.plant.name)
                                            .fontWeight(.medium)
                                        
                                        HStack {
                                            Image(systemName: "clock")
                                                .font(.caption)
                                            
                                            Text("\(item.plant.growthTime) days")
                                                .font(.caption)
                                        }
                                        .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("x\(item.quantity)")
                                        .fontWeight(.medium)
                                        .padding(8)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Plant")
        }
    }
}

// Stand-alone farm view to use for navigation
struct FarmView: View {
    var body: some View {
        FarmMapView()
    }
}
