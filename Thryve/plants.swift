import SwiftUI

// Extended Plant model with additional properties
struct Plant: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let careInstructions: String
    let price: Double
    let imageName: String
    let growthTime: Int // in days
    let waterNeeds: String // Low, Medium, High
    let sunNeeds: String // Full sun, Partial shade, Shade
    let category: String // Vegetable, Fruit, Herb, Flower, etc.
    let harvestValue: Int // Coins earned when harvested
    
    // For display
    var placeholder: String {
        return emoji
    }
    
    // Calculate bonus harvest amount (if any)
    func calculateBonusHarvest() -> Int {
        // Calculate chance based on rarity/quality
        let chance = Double.random(in: 0...1)
        
        if chance < 0.2 {
            return Int.random(in: 1...3)
        }
        return 0
    }
    
    // Get emoji representation based on type
    var emoji: String {
        switch self.category {
        case "Vegetable":
            if self.name.contains("Tomato") { return "🍅" }
            if self.name.contains("Carrot") { return "🥕" }
            if self.name.contains("Corn") { return "🌽" }
            if self.name.contains("Potato") { return "🥔" }
            if self.name.contains("Eggplant") { return "🍆" }
            return "🥬"
            
        case "Fruit":
            if self.name.contains("Apple") { return "🍎" }
            if self.name.contains("Banana") { return "🍌" }
            if self.name.contains("Orange") { return "🍊" }
            if self.name.contains("Strawberry") { return "🍓" }
            if self.name.contains("Watermelon") { return "🍉" }
            if self.name.contains("Pineapple") { return "🍍" }
            return "🍇"
            
        case "Flower":
            if self.name.contains("Rose") { return "🌹" }
            if self.name.contains("Tulip") { return "🌷" }
            if self.name.contains("Sunflower") { return "🌻" }
            return "🌸"
            
        case "Herb":
            return "🌿"
            
        default:
            return "🌱"
        }
    }
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Inventory item model
struct InventoryItem: Codable, Identifiable, Hashable {
    var id = UUID()
    let plant: Plant
    var quantity: Int
    
    init(plant: Plant, quantity: Int = 1) {
        self.plant = plant
        self.quantity = quantity
    }
    
    static func == (lhs: InventoryItem, rhs: InventoryItem) -> Bool {
        return lhs.plant.id == rhs.plant.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plant.id)
    }
}
