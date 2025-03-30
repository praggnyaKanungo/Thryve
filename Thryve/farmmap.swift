import SwiftUI

// FarmMap manager class to track and manage the farm plots
class FarmMapManager: ObservableObject {
    // Singleton instance for app-wide access
    static let shared = FarmMapManager()
    
    // Number of plots in the farm
    let rows = 3
    let columns = 4
    let totalPlots = 12
    
    // Farm plots array
    @Published var plots: [FarmPlot] = [] {
        didSet {
            saveFarmData()
        }
    }
    
    // Currently selected plot
    @Published var selectedPlotIndex: Int?
    
    // Donation tracking
    @Published var totalSuccessfulHarvests: Int = 0 {
        didSet {
            saveDonationProgress()
            checkDonationMilestone()
        }
    }
    
    @Published var donations: [Donation] = [] {
        didSet {
            saveDonations()
        }
    }
    
    // Initialize with saved farm data if available
    private init() {
        loadFarmData()
        loadDonationProgress()
        loadDonations()
        
        // If no saved data, create empty plots
        if plots.isEmpty {
            for i in 0..<totalPlots {
                plots.append(FarmPlot(id: i))
            }
        }
    }
    
    // Save farm data to UserDefaults
    private func saveFarmData() {
        if let encoded = try? JSONEncoder().encode(plots) {
            UserDefaults.standard.set(encoded, forKey: "farmPlots")
        }
    }
    
    // Load farm data from UserDefaults
    private func loadFarmData() {
        if let savedFarmData = UserDefaults.standard.data(forKey: "farmPlots"),
           let decodedFarmData = try? JSONDecoder().decode([FarmPlot].self, from: savedFarmData) {
            plots = decodedFarmData
        }
    }
    
    // Save donation progress
    private func saveDonationProgress() {
        UserDefaults.standard.set(totalSuccessfulHarvests, forKey: "totalSuccessfulHarvests")
    }
    
    // Load donation progress
    private func loadDonationProgress() {
        if let harvests = UserDefaults.standard.object(forKey: "totalSuccessfulHarvests") as? Int {
            totalSuccessfulHarvests = harvests
        }
    }
    
    // Save donations
    private func saveDonations() {
        if let encoded = try? JSONEncoder().encode(donations) {
            UserDefaults.standard.set(encoded, forKey: "donations")
        }
    }
    
    // Load donations
    private func loadDonations() {
        if let savedData = UserDefaults.standard.data(forKey: "donations"),
           let decodedData = try? JSONDecoder().decode([Donation].self, from: savedData) {
            donations = decodedData
        }
    }
    
    // Check for donation milestone
    private func checkDonationMilestone() {
        // Every 10 successful harvests triggers a $10 donation
        if totalSuccessfulHarvests > 0 && totalSuccessfulHarvests % 10 == 0 {
            // Record the donation
            let newDonation = Donation(
                amount: 10,
                organization: "Green Earth Foundation"
            )
            donations.append(newDonation)
        }
    }
    
    // Update the plantInPlot method in FarmMapManager
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
                    
                    // Start the game timer if this is the first plant
                    if !GameTimerManager.shared.isTimerRunning {
                        GameTimerManager.shared.startTimer()
                    }
                    
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
                // Base harvest value
                CoinsManager.shared.addCoins(plant.harvestValue, reason: "Harvested \(plant.name)")
                
                // Calculate bonus harvest (if any)
                let bonusHarvest = plant.calculateBonusHarvest()
                if bonusHarvest > 0 {
                    CoinsManager.shared.addCoins(bonusHarvest * (plant.harvestValue / 2), reason: "Bonus harvest from \(plant.name)!")
                    
                    // Add bonus seeds back to inventory
                    let inventory = InventoryManager.shared
                    inventory.addItem(plant: plant, quantity: bonusHarvest)
                }
                
                // Add to successful harvests count
                totalSuccessfulHarvests += 1
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
        // Get calendar
        let calendar = GameCalendar.shared
        
        for i in 0..<plots.count {
            // Grow plants that have been watered
            if plots[i].status == .planted && plots[i].isWatered && plots[i].plant != nil {
                // Calculate growth specifically for this plant type
                let growthAmount = calendar.calculateDailyGrowth(for: plots[i].plant!)
                
                // Apply growth
                plots[i].growthProgress += growthAmount
                
                // Cap growth progress at 1.0 (100%)
                if plots[i].growthProgress > 1.0 {
                    plots[i].growthProgress = 1.0
                }
                
                // Reset watered status
                plots[i].isWatered = false
            }
        }
        
        // Advance the game calendar
        calendar.advanceDay()
    }
    
    // Reset farm (for testing/reset)
    func resetFarm() {
        for i in 0..<plots.count {
            plots[i] = FarmPlot(id: i)
        }
    }
}
