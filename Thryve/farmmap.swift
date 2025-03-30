import SwiftUI

class FarmMapManager: ObservableObject {
    static let shared = FarmMapManager()
    
    let rows = 3
    let columns = 4
    let totalPlots = 12
    
    @Published var plots: [FarmPlot] = [] {
        didSet {
            saveFarmData()
        }
    }
    
    @Published var selectedPlotIndex: Int?
    
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
    
    private init() {
        loadFarmData()
        loadDonationProgress()
        loadDonations()
        
        if plots.isEmpty {
            for i in 0..<totalPlots {
                plots.append(FarmPlot(id: i))
            }
        }
    }
    
    private func saveFarmData() {
        if let encoded = try? JSONEncoder().encode(plots) {
            UserDefaults.standard.set(encoded, forKey: "farmPlots")
        }
    }
    
    private func loadFarmData() {
        if let savedFarmData = UserDefaults.standard.data(forKey: "farmPlots"),
           let decodedFarmData = try? JSONDecoder().decode([FarmPlot].self, from: savedFarmData) {
            plots = decodedFarmData
        }
    }
    
    private func saveDonationProgress() {
        UserDefaults.standard.set(totalSuccessfulHarvests, forKey: "totalSuccessfulHarvests")
    }
    
    private func loadDonationProgress() {
        if let harvests = UserDefaults.standard.object(forKey: "totalSuccessfulHarvests") as? Int {
            totalSuccessfulHarvests = harvests
        }
    }
    
    private func saveDonations() {
        if let encoded = try? JSONEncoder().encode(donations) {
            UserDefaults.standard.set(encoded, forKey: "donations")
        }
    }
    
    private func loadDonations() {
        if let savedData = UserDefaults.standard.data(forKey: "donations"),
           let decodedData = try? JSONDecoder().decode([Donation].self, from: savedData) {
            donations = decodedData
        }
    }
    
    private func checkDonationMilestone() {
        if totalSuccessfulHarvests > 0 && totalSuccessfulHarvests % 10 == 0 {
            let newDonation = Donation(
                amount: 10,
                organization: "Green Earth Foundation"
            )
            donations.append(newDonation)
        }
    }
    
    func plantInPlot(plotIndex: Int, plant: Plant) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        let plot = plots[plotIndex]
        
        if plot.status == .empty || plot.status == .tilled {
            let inventory = InventoryManager.shared
            
            if inventory.hasItem(plantId: plant.id) {
                let success = inventory.removeItem(plantId: plant.id, quantity: 1)
                
                if success {
                    plots[plotIndex].plantCrop(plant: plant)
                    
                    if !GameTimerManager.shared.isTimerRunning {
                        GameTimerManager.shared.startTimer()
                    }
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func tillPlot(plotIndex: Int) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        if plots[plotIndex].status == .empty {
            plots[plotIndex].status = .tilled
            return true
        }
        
        return false
    }
    
    func waterPlot(plotIndex: Int) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        if plots[plotIndex].status == .planted && !plots[plotIndex].isWatered {
            plots[plotIndex].isWatered = true
            return true
        }
        
        return false
    }
    
    func harvestPlot(plotIndex: Int) -> Bool {
        guard plotIndex >= 0 && plotIndex < plots.count else { return false }
        
        let plot = plots[plotIndex]
        
        if plot.status == .planted && plot.isReadyToHarvest {
            if let plant = plot.plant {
                CoinsManager.shared.addCoins(plant.harvestValue, reason: "Harvested \(plant.name)")
                
                let bonusHarvest = plant.calculateBonusHarvest()
                if bonusHarvest > 0 {
                    CoinsManager.shared.addCoins(bonusHarvest * (plant.harvestValue / 2), reason: "Bonus harvest from \(plant.name)!")
                    
                    let inventory = InventoryManager.shared
                    inventory.addItem(plant: plant, quantity: bonusHarvest)
                }
                
                totalSuccessfulHarvests += 1
            }
            
            plots[plotIndex].status = .tilled
            plots[plotIndex].plant = nil
            plots[plotIndex].plantedDate = nil
            plots[plotIndex].isWatered = false
            
            return true
        }
        
        return false
    }
    
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
    
    func advanceDay() {
        let calendar = GameCalendar.shared
        
        for i in 0..<plots.count {
            if plots[i].status == .planted && plots[i].isWatered && plots[i].plant != nil {
                let growthAmount = calendar.calculateDailyGrowth(for: plots[i].plant!)
                
                plots[i].growthProgress += growthAmount
                
                if plots[i].growthProgress > 1.0 {
                    plots[i].growthProgress = 1.0
                }
                
                plots[i].isWatered = false
            }
        }
        
        calendar.advanceDay()
    }
    
}

extension FarmMapManager {
    func resetFarm() {
        for i in 0..<plots.count {
            plots[i] = FarmPlot(id: i)
        }
        
        selectedPlotIndex = nil
        
        totalSuccessfulHarvests = 0
        donations = []
        
        UserDefaults.standard.removeObject(forKey: "farmPlots")
        UserDefaults.standard.removeObject(forKey: "totalSuccessfulHarvests")
        UserDefaults.standard.removeObject(forKey: "donations")
        
        saveFarmData()
    }
}
