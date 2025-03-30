import SwiftUI

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
                                    ZStack {
                                        Circle()
                                            .fill(Color.green.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                        
                                        Text(item.plant.emoji)
                                            .font(.title2)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.plant.name)
                                            .fontWeight(.medium)
                                        
                                        HStack {
                                            Image(systemName: "clock")
                                                .font(.caption)
                                            
                                            Text("\(item.plant.growthTime) days")
                                                .font(.caption)
                                            
                                            Image(systemName: "dollarsign.circle")
                                                .font(.caption)
                                            
                                            Text("Value: \(item.plant.harvestValue)")
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
