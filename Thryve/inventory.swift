import SwiftUI

// Inventory manager to track player's items across the app
class InventoryManager: ObservableObject {
    // Singleton instance for app-wide access
    static let shared = InventoryManager()
    
    // Player's inventory items
    @Published var items: [InventoryItem] = [] {
        didSet {
            saveInventory()
        }
    }
    
    // Initialize with saved inventory if available
    private init() {
        loadInventory()
    }
    
    // Add item to inventory
    func addItem(plant: Plant, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.plant.id == plant.id }) {
            // Item already exists, update quantity
            items[index].quantity += quantity
        } else {
            // New item, add to inventory
            items.append(InventoryItem(plant: plant, quantity: quantity))
        }
    }
    
    // Remove item from inventory
    func removeItem(plantId: UUID, quantity: Int = 1) -> Bool {
        if let index = items.firstIndex(where: { $0.plant.id == plantId }) {
            if items[index].quantity > quantity {
                // Reduce quantity
                items[index].quantity -= quantity
                return true
            } else if items[index].quantity == quantity {
                // Remove item completely
                items.remove(at: index)
                return true
            }
        }
        return false
    }
    
    // Check if player has specific item
    func hasItem(plantId: UUID, quantity: Int = 1) -> Bool {
        return items.contains(where: { $0.plant.id == plantId && $0.quantity >= quantity })
    }
    
    // Get quantity of a specific item
    func quantityOf(plantId: UUID) -> Int {
        if let item = items.first(where: { $0.plant.id == plantId }) {
            return item.quantity
        }
        return 0
    }
    
    // Get total items in inventory
    var totalItems: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    // Get items sorted by category
    func itemsByCategory() -> [String: [InventoryItem]] {
        return Dictionary(grouping: items) { $0.plant.category }
    }
    
    // Save inventory to UserDefaults
    private func saveInventory() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "playerInventory")
        }
    }
    
    // Load inventory from UserDefaults
    private func loadInventory() {
        if let savedInventory = UserDefaults.standard.data(forKey: "playerInventory"),
           let decodedInventory = try? JSONDecoder().decode([InventoryItem].self, from: savedInventory) {
            items = decodedInventory
        }
    }
    
    /*
    // Clear inventory (for testing/reset)
    func clearInventory() {
        items = []
    }
    */
    
    // Add starter items for new players
    func addStarterItems() {
        // Add some basic seeds to get started
        // You need to have a way to get Plant objects here, possibly from a catalog
        if let tomatoPlant = PlantCatalog.shared.getPlant(name: "Tomato") {
            addItem(plant: tomatoPlant, quantity: 5)
        }
        
        if let carrotPlant = PlantCatalog.shared.getPlant(name: "Carrot") {
            addItem(plant: carrotPlant, quantity: 3)
        }
    }
}

// Inventory manager extension with improved reset functionality
extension InventoryManager {
    // Clear inventory (for testing/reset)
    func clearInventory() {
        items = []
        
        // Remove from UserDefaults
        UserDefaults.standard.removeObject(forKey: "playerInventory")
    }
}
