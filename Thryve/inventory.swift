import SwiftUI

// Inventory manager class to track and manage user's items across the app
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
    
    // Clear inventory (for testing/reset)
    func clearInventory() {
        items = []
    }
}

// Inventory item model
struct InventoryItem: Codable, Identifiable {
    var id = UUID()
    let plant: Plant
    var quantity: Int
    var isPlanted: Bool = false
    var plantedDate: Date?
    
    // For farming mechanic
    var growthProgress: Double {
        guard let plantedDate = plantedDate, isPlanted else { return 0 }
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(plantedDate)
        let daysPassed = timeInterval / (60 * 60 * 24) // Convert seconds to days
        
        // Calculate growth based on plant's growth time
        return min(daysPassed / Double(plant.growthTime), 1.0)
    }
    
    var isReadyToHarvest: Bool {
        return isPlanted && growthProgress >= 1.0
    }
}

// Extended Plant model with additional properties
struct Plant: Codable, Identifiable {
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
        return String(name.prefix(1))
    }
}

// Inventory Grid Item View
struct InventoryGridItem: View {
    let item: InventoryItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.green.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                    
                    Text(item.plant.placeholder)
                        .font(.title)
                        .foregroundColor(.green)
                        
                    if item.isPlanted {
                        ProgressView(value: item.growthProgress)
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                    }
                }
                .frame(height: 100)
                .cornerRadius(10)
                
                Text(item.plant.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text("x\(item.quantity)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 5)
        }
    }
}

// Inventory Detail View
struct InventoryDetailView: View {
    @ObservedObject var inventoryManager = InventoryManager.shared
    let item: InventoryItem
    @State private var showingPlantInfo = false
    @State private var quantityToPlant = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(item.plant.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("Qty: \(item.quantity)")
                    .font(.headline)
            }
            
            ZStack {
                Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(10)
                
                Text(item.plant.placeholder)
                    .font(.system(size: 80))
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("About this plant")
                    .font(.headline)
                
                Text(item.plant.description)
                    .font(.body)
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Growth Time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("\(item.plant.growthTime) days")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Water Needs")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(item.plant.waterNeeds)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Sunlight")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(item.plant.sunNeeds)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Divider()
                
                HStack {
                    Text("Harvest Value")
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.yellow)
                        
                        Text("\(item.plant.harvestValue)")
                            .font(.headline)
                    }
                }
            }
            
            Spacer()
            
            // Action buttons
            HStack {
                Spacer()
                
                Button(action: {
                    showingPlantInfo = true
                }) {
                    Text("Care Instructions")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                NavigationLink(destination: FarmingView(selectedPlant: item.plant, quantity: quantityToPlant, inventory: inventoryManager)) {
                    Text("Plant")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding(.bottom)
        }
        .padding()
        .alert(isPresented: $showingPlantInfo) {
            Alert(
                title: Text("Care Instructions"),
                message: Text(item.plant.careInstructions),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Plant Details")
    }
}

// Inventory Overview View
struct InventoryView: View {
    @ObservedObject var inventoryManager = InventoryManager.shared
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    
    // Categories for filtering
    var categories: [String] {
        let categories = Set(inventoryManager.items.map { $0.plant.category })
        return Array(categories).sorted()
    }
    
    // Filtered items based on search and category
    var filteredItems: [InventoryItem] {
        var items = inventoryManager.items
        
        // Apply category filter
        if let category = selectedCategory {
            items = items.filter { $0.plant.category == category }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            items = items.filter { $0.plant.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return items
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search plants", text: $searchText)
                        .foregroundColor(.primary)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Category filter
                if !categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Button(action: {
                                selectedCategory = nil
                            }) {
                                Text("All")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedCategory == nil ? Color.green : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedCategory == nil ? .white : .primary)
                                    .cornerRadius(20)
                            }
                            
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedCategory == category ? Color.green : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedCategory == category ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                
                // Inventory content
                if inventoryManager.items.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.gray)
                        
                        Text("Your inventory is empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Visit the shop to buy seeds and plants")
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: ShoppingView()) {
                            Text("Go Shopping")
                                .fontWeight(.semibold)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                } else {
                    if filteredItems.isEmpty {
                        Spacer()
                        Text("No plants match your search")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        // Grid of inventory items
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                                ForEach(filteredItems) { item in
                                    NavigationLink(destination: InventoryDetailView(item: item)) {
                                        InventoryGridItem(item: item) { }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Total: \(inventoryManager.totalItems)")
                        .fontWeight(.medium)
                }
            }
        }
    }
}

// Simple Farming View
struct FarmingView: View {
    let selectedPlant: Plant
    let quantity: Int
    @ObservedObject var inventory: InventoryManager
    @State private var showingConfirmation = false
    @State private var planted = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Plant in Your Farm")
                .font(.largeTitle)
                .padding()
            
            ZStack {
                Rectangle()
                    .fill(Color.green.opacity(0.2))
                    .frame(height: 250)
                    .cornerRadius(15)
                
                if planted {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.green)
                } else {
                    VStack(spacing: 20) {
                        Text(selectedPlant.placeholder)
                            .font(.system(size: 80))
                            .foregroundColor(.green.opacity(0.5))
                        
                        Text("Ready to plant")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                Text(selectedPlant.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Growth Time:")
                        .fontWeight(.medium)
                    
                    Text("\(selectedPlant.growthTime) days")
                }
                
                HStack {
                    Text("Care:")
                        .fontWeight(.medium)
                    
                    Text(selectedPlant.waterNeeds)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text(selectedPlant.sunNeeds)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(8)
                }
                
                HStack {
                    Text("Harvest Value:")
                        .fontWeight(.medium)
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    
                    Text("\(selectedPlant.harvestValue)")
                        .fontWeight(.bold)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
            
            Spacer()
            
            if !planted {
                Button(action: {
                    showingConfirmation = true
                }) {
                    Text("Plant Now")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showingConfirmation) {
                    Alert(
                        title: Text("Confirm Planting"),
                        message: Text("Are you sure you want to plant \(quantity) \(selectedPlant.name)?"),
                        primaryButton: .default(Text("Plant")) {
                            // Remove from inventory
                            let success = inventory.removeItem(plantId: selectedPlant.id, quantity: quantity)
                            
                            if success {
                                // Add to planted items
                                // In a real app, you would probably have a separate PlantedItemsManager
                                planted = true
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            } else {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Return to Farm")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationTitle("Planting")
    }
}

