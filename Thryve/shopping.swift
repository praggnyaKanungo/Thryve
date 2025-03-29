import SwiftUI

// Cart item model
struct CartItem: Identifiable {
    let id = UUID()
    let plant: Plant
    var quantity: Int
}

// MARK: - Plant Detail View Component
struct PlantDetailView: View {
    let plant: Plant
    let quantity: Int
    let onQuantityDecreased: () -> Void
    let onQuantityIncreased: () -> Void
    let onAddToCart: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with plant name and close button
            HStack {
                Text(plant.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            
            // Plant image placeholder
            ZStack {
                Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(10)
                
                Text(plant.placeholder)
                    .font(.system(size: 50))
                    .foregroundColor(.green)
            }
            
            // Plant details
            Group {
                Text("About this plant")
                    .font(.headline)
                
                Text(plant.description)
                    .font(.body)
                
                Text("How to grow")
                    .font(.headline)
                
                Text(plant.careInstructions)
                    .font(.body)
                
                // Additional growing information
                HStack(spacing: 20) {
                    VStack {
                        Image(systemName: "calendar")
                        Text("\(plant.growthTime) days")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "drop.fill")
                        Text(plant.waterNeeds)
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "sun.max.fill")
                        Text(plant.sunNeeds)
                            .font(.caption)
                    }
                }
                .padding(.vertical)
            }
            
            // Price and purchase controls
            HStack {
                Text("$\(plant.price, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Quantity stepper
                HStack {
                    Button(action: onQuantityDecreased) {
                        Image(systemName: "minus.circle")
                    }
                    
                    Text("\(quantity)")
                        .frame(width: 30)
                    
                    Button(action: onQuantityIncreased) {
                        Image(systemName: "plus.circle")
                    }
                }
                
                Button(action: onAddToCart) {
                    Text("Add to Cart")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}

// MARK: - Cart View Component
struct CartView: View {
    let cartItems: [CartItem]
    let total: Double
    let onClose: () -> Void
    let onCheckout: () -> Void
    let onDeleteItems: (IndexSet) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Shopping Cart")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            
            if cartItems.isEmpty {
                Spacer()
                Text("Your cart is empty")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(cartItems) { item in
                        CartItemRow(item: item)
                    }
                    .onDelete(perform: onDeleteItems)
                }
                
                Divider()
                
                HStack {
                    Text("Total:")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("$\(total, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .padding()
                
                Button(action: onCheckout) {
                    Text("Checkout")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}

// MARK: - Cart Item Row
struct CartItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack {
            // Plant image placeholder
            ZStack {
                Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                
                Text(item.plant.placeholder)
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading) {
                Text(item.plant.name)
                    .fontWeight(.semibold)
                
                Text("$\(item.plant.price, specifier: "%.2f") each")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("x\(item.quantity)")
                .font(.callout)
                .foregroundColor(.gray)
            
            Text("$\(item.plant.price * Double(item.quantity), specifier: "%.2f")")
                .fontWeight(.medium)
        }
    }
}

// MARK: - Checkout Success View
struct CheckoutSuccessView: View {
    let onContinueShopping: () -> Void
    let onStartFarming: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Purchase Successful!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your plants have been added to your inventory.")
                .multilineTextAlignment(.center)
            
            Divider()
            
            Text("What would you like to do next?")
                .font(.headline)
            
            HStack(spacing: 20) {
                Button(action: onContinueShopping) {
                    Text("Continue Shopping")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                }
                
                Button(action: onStartFarming) {
                    Text("Start Farming")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(30)
    }
}

// MARK: - Not Enough Coins Alert
struct NotEnoughCoinsAlert: View {
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Not Enough Coins")
                .font(.title)
                .fontWeight(.bold)
            
            Text("You don't have enough coins for this purchase.")
                .multilineTextAlignment(.center)
            
            Button(action: onDismiss) {
                Text("OK")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(width: 100)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(30)
    }
}

// Individual plant grid item for shopping
struct PlantGridItem: View {
    let plant: Plant
    
    var body: some View {
        VStack {
            // This will be replaced with Image(plant.imageName) when you add images
            ZStack {
                Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
                
                Text(plant.placeholder)
                    .font(.title)
                    .foregroundColor(.green)
            }
            .frame(height: 100)
            .cornerRadius(10)
            
            Text(plant.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
            
            Text("$\(plant.price, specifier: "%.2f")")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Shopping View Model
class ShoppingViewModel: ObservableObject {
    // Shopping System
    @Published var cartItems: [CartItem] = []
    @Published var selectedPlant: Plant?
    @Published var quantity: Int = 1
    @Published var showingCart = false
    @Published var showCheckoutSuccess = false
    @Published var hasMadePurchase = false
    @Published var showNotEnoughCoinsAlert = false
    
    // Reference to shared managers
    private let coinsManager = CoinsManager.shared
    private let inventoryManager = InventoryManager.shared
    
    // Sample plants available in the shop
    let availablePlants: [Plant] = [
        Plant(
            id: UUID(),
            name: "Tomato",
            description: "Red, juicy fruit that's technically a berry. Great for salads and sauces.",
            careInstructions: "Water regularly, provide support for vines, and harvest when fully red.",
            price: 20,
            imageName: "tomato",
            growthTime: 3,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 40
        ),
        Plant(
            id: UUID(),
            name: "Carrot",
            description: "Orange root vegetable, sweet and crunchy. Good source of vitamins.",
            careInstructions: "Grow in loose soil, thin seedlings, keep soil consistently moist.",
            price: 15,
            imageName: "carrot",
            growthTime: 3,
            waterNeeds: "Medium",
            sunNeeds: "Full sun",
            category: "Vegetable",
            harvestValue: 30
        ),
        // Add more plants here...
    ]
    
    // Add item to cart with coin check
    func addToCart(plant: Plant, quantity: Int) -> Bool {
        let totalCost = plant.price * Double(quantity)
        
        // Check if player has enough coins
        if Double(coinsManager.totalCoins) < totalCost {
            return false
        }
        
        // Add to cart
        if let index = cartItems.firstIndex(where: { $0.plant.id == plant.id }) {
            // Item already in cart, update quantity
            cartItems[index].quantity += quantity
        } else {
            // New item
            cartItems.append(CartItem(plant: plant, quantity: quantity))
        }
        
        return true
    }
    
    // Remove item from cart
    func removeFromCart(at indexSet: IndexSet) {
        cartItems.remove(atOffsets: indexSet)
    }
    
    // Calculate total cost
    var total: Double {
        cartItems.reduce(0) { $0 + ($1.plant.price * Double($1.quantity)) }
    }
    
    // Checkout process
    func checkout() -> Bool {
        // Check if player has enough coins for total
        let totalCost = total
        
        if Double(coinsManager.totalCoins) < totalCost {
            return false
        }
        
        // Spend coins
        let success = coinsManager.spendCoins(Int(totalCost), reason: "Purchased plants from shop")
        
        if success {
            // Add items to inventory
            for item in cartItems {
                inventoryManager.addItem(plant: item.plant, quantity: item.quantity)
            }
            
            // Clear cart and show confirmation
            cartItems = []
            showingCart = false
            showCheckoutSuccess = true
            hasMadePurchase = true
            
            return true
        }
        
        return false
    }
}

// MARK: - Main Shopping View
struct ShoppingView: View {
    @ObservedObject private var coinsManager = CoinsManager.shared
    @ObservedObject private var inventoryManager = InventoryManager.shared
    @StateObject private var viewModel = ShoppingViewModel()
    @State private var searchText = ""
    @State private var navigateToFarming = false
    
    // Filtered plants based on search
    var filteredPlants: [Plant] {
        if searchText.isEmpty {
            return viewModel.availablePlants
        } else {
            return viewModel.availablePlants.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            // Main content
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
                
                // Plant grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                        ForEach(filteredPlants) { plant in
                            Button(action: {
                                viewModel.selectedPlant = plant
                                viewModel.quantity = 1
                            }) {
                                PlantGridItem(plant: plant)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // Overlays
            overlayViews
            
            // Hidden navigation to farming
            NavigationLink("", destination: FarmMapView(), isActive: $navigateToFarming)
                .hidden()
        }
        .navigationTitle("Plant Shop")
        .toolbar {
            toolbarContent
        }
    }
    
    // MARK: - View Components
    
    // Overlay views (separated to reduce complexity)
    @ViewBuilder
    private var overlayViews: some View {
        // Plant detail overlay
        if let selectedPlant = viewModel.selectedPlant {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    viewModel.selectedPlant = nil
                }
            
            PlantDetailView(
                plant: selectedPlant,
                quantity: viewModel.quantity,
                onQuantityDecreased: {
                    if viewModel.quantity > 1 {
                        viewModel.quantity -= 1
                    }
                },
                onQuantityIncreased: {
                    viewModel.quantity += 1
                },
                onAddToCart: {
                    let success = viewModel.addToCart(plant: selectedPlant, quantity: viewModel.quantity)
                    if !success {
                        viewModel.showNotEnoughCoinsAlert = true
                    } else {
                        viewModel.selectedPlant = nil
                    }
                },
                onClose: {
                    viewModel.selectedPlant = nil
                }
            )
            .transition(.opacity)
            .animation(.easeInOut, value: viewModel.selectedPlant != nil)
        }
        
        // Cart view overlay
        if viewModel.showingCart {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    viewModel.showingCart = false
                }
            
            CartView(
                cartItems: viewModel.cartItems,
                total: viewModel.total,
                onClose: {
                    viewModel.showingCart = false
                },
                onCheckout: {
                    let success = viewModel.checkout()
                    if !success {
                        viewModel.showNotEnoughCoinsAlert = true
                    }
                },
                onDeleteItems: viewModel.removeFromCart
            )
            .frame(maxWidth: .infinity, maxHeight: viewModel.cartItems.isEmpty ? 300 : .infinity)
            .transition(.opacity)
            .animation(.easeInOut, value: viewModel.showingCart)
        }
        
        // Checkout success overlay
        if viewModel.showCheckoutSuccess {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    viewModel.showCheckoutSuccess = false
                }
            
            CheckoutSuccessView(
                onContinueShopping: {
                    viewModel.showCheckoutSuccess = false
                },
                onStartFarming: {
                    navigateToFarming = true
                    viewModel.showCheckoutSuccess = false
                }
            )
            .transition(.scale)
            .animation(.spring(), value: viewModel.showCheckoutSuccess)
        }
        
        // Not enough coins alert
        if viewModel.showNotEnoughCoinsAlert {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    viewModel.showNotEnoughCoinsAlert = false
                }
            
            NotEnoughCoinsAlert(onDismiss: {
                viewModel.showNotEnoughCoinsAlert = false
            })
        }
    }
    
    // Toolbar content (separated to reduce complexity)
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        // Left side navigation item - Map icon to Start Farming
        ToolbarItem(placement: .navigationBarLeading) {
            if viewModel.hasMadePurchase {
                Button(action: {
                    navigateToFarming = true
                }) {
                    Image(systemName: "map.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
        }
        
        // Right side navigation items
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 20) {
                // Coins display
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    
                    Text("\(coinsManager.totalCoins)")
                        .fontWeight(.bold)
                }
                
                // Cart button
                Button(action: {
                    viewModel.showingCart = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.title2)
                        
                        if !viewModel.cartItems.isEmpty {
                            Text("\(viewModel.cartItems.reduce(0) { $0 + $1.quantity })")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                    }
                }
            }
        }
    }
}

// Preview provider
struct ShoppingView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingView()
    }
}
