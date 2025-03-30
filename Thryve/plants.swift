import SwiftUI

struct Plant: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let careInstructions: String
    let price: Double
    let imageName: String
    let growthTime: Int 
    let waterNeeds: String 
    let sunNeeds: String 
    let category: String
    let harvestValue: Int 
    
    var placeholder: String {
        return emoji
    }
    
    func calculateBonusHarvest() -> Int {
        let chance = Double.random(in: 0...1)
        
        if chance < 0.2 {
            return Int.random(in: 1...3)
        }
        return 0
    }
    
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
