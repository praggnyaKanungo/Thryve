import SwiftUI

// Plot status enum
enum PlotStatus: String, Codable {
    case empty
    case tilled
    case planted
}

// Plant growth stages enum
enum GrowthStage: String, Codable {
    case seed
    case sprout
    case growing
    case mature
}

// Farm plot model
struct FarmPlot: Codable, Identifiable {
    let id: Int
    var status: PlotStatus = .empty
    var plant: Plant?
    var plantedDate: Date?
    var isWatered: Bool = false
    var growthProgress: Double = 0
    
    // Get current growth stage based on progress
    var currentGrowthStage: GrowthStage {
        guard status == .planted, growthProgress > 0 else { return .seed }
        
        if growthProgress < 0.3 {
            return .seed
        } else if growthProgress < 0.6 {
            return .sprout
        } else if growthProgress < 1.0 {
            return .growing
        } else {
            return .mature
        }
    }
    
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

// Donation tracking
struct Donation: Identifiable, Codable {
    let id: UUID
    let date: Date
    let amount: Int
    let organization: String
    
    init(amount: Int, organization: String) {
        self.id = UUID()
        self.date = Date()
        self.amount = amount
        self.organization = organization
    }
}
