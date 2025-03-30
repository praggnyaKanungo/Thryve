import SwiftUI
struct InventoryView: View {
    @ObservedObject var inventoryManager = InventoryManager.shared
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @Environment(\.presentationMode) var presentationMode
    
    var categories: [String] {
        let categories = Set(inventoryManager.items.map { $0.plant.category })
        return Array(categories).sorted()
    }
    
    var filteredItems: [InventoryItem] {
        var items = inventoryManager.items
        
        if let category = selectedCategory {
            items = items.filter { $0.plant.category == category }
        }
        
        if !searchText.isEmpty {
            items = items.filter { $0.plant.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return items
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                                ForEach(filteredItems) { item in
                                    InventoryItemView(item: item)
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                }
                .padding()
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

struct InventoryItemView: View {
    let item: InventoryItem
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 80, height: 80)
                
                Text(item.plant.emoji)
                    .font(.system(size: 40))
            }
            
            Text(item.plant.name)
                .font(.headline)
                .lineLimit(1)
            
            HStack {
                Image(systemName: "number")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("\(item.quantity)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Image(systemName: "dollarsign.circle")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("\(item.plant.harvestValue)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
