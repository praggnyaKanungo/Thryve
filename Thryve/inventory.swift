import SwiftUI

class InventoryManager: ObservableObject {
    static let shared = InventoryManager()
    
    @Published var items: [InventoryItem] = [] {
        didSet {
            saveInventory()
        }
    }
    
    private init() {
        loadInventory()
    }
    
    func addItem(plant: Plant, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.plant.id == plant.id }) {
            items[index].quantity += quantity
        } else {
            items.append(InventoryItem(plant: plant, quantity: quantity))
        }
    }
    
    func removeItem(plantId: UUID, quantity: Int = 1) -> Bool {
        if let index = items.firstIndex(where: { $0.plant.id == plantId }) {
            if items[index].quantity > quantity {
                items[index].quantity -= quantity
                return true
            } else if items[index].quantity == quantity {
                items.remove(at: index)
                return true
            }
        }
        return false
    }
    
    func hasItem(plantId: UUID, quantity: Int = 1) -> Bool {
        return items.contains(where: { $0.plant.id == plantId && $0.quantity >= quantity })
    }
    
    func quantityOf(plantId: UUID) -> Int {
        if let item = items.first(where: { $0.plant.id == plantId }) {
            return item.quantity
        }
        return 0
    }
    
    var totalItems: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    func itemsByCategory() -> [String: [InventoryItem]] {
        return Dictionary(grouping: items) { $0.plant.category }
    }
    
    private func saveInventory() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "playerInventory")
        }
    }
    
    private func loadInventory() {
        if let savedInventory = UserDefaults.standard.data(forKey: "playerInventory"),
           let decodedInventory = try? JSONDecoder().decode([InventoryItem].self, from: savedInventory) {
            items = decodedInventory
        }
    }
    

    
    func addStarterItems() {

        if let tomatoPlant = PlantCatalog.shared.getPlant(name: "Tomato") {
            addItem(plant: tomatoPlant, quantity: 5)
        }
        
        if let carrotPlant = PlantCatalog.shared.getPlant(name: "Carrot") {
            addItem(plant: carrotPlant, quantity: 3)
        }
    }
}

extension InventoryManager {
    func clearInventory() {
        items = []
        UserDefaults.standard.removeObject(forKey: "playerInventory")
    }
}
