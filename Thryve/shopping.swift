import SwiftUI

struct CartItem: Identifiable {
    let id = UUID()
    let plant: Plant
    var quantity: Int
}

struct PlantDetailView: View {
    let plant: Plant
    let quantity: Int
    let onQuantityDecreased: () -> Void
    let onQuantityIncreased: () -> Void
    let onAddToCart: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
            
            ZStack {
                Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(10)
                
                Text(plant.placeholder)
                    .font(.system(size: 50))
                    .foregroundColor(.green)
            }
            
            Group {
                Text("About this plant")
                    .font(.headline)
                
                Text(plant.description)
                    .font(.body)
                
                Text("How to grow")
                    .font(.headline)
                
                Text(plant.careInstructions)
                    .font(.body)
                
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
            
            HStack {
                Text("$\(plant.price, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
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

struct CartItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack {
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

struct PlantGridItem: View {
    let plant: Plant
    
    var body: some View {
        VStack {
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
            
            VStack(alignment: .leading, spacing: 2) {
                Text(plant.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(plant.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("$\(plant.price, specifier: "%.2f")")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 5)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.vertical, 5)
    }
}

class ShoppingViewModel: ObservableObject {
    
    @Published var cartItems: [CartItem] = []
    @Published var selectedPlant: Plant?
    @Published var quantity: Int = 1
    @Published var showingCart = false
    @Published var showCheckoutSuccess = false
    @Published var hasMadePurchase = false
    @Published var showNotEnoughCoinsAlert = false
    
    private let coinsManager = CoinsManager.shared
    private let inventoryManager = InventoryManager.shared
    private let plantCatalog = PlantCatalog.shared
    
    var availablePlants: [Plant] {
        return plantCatalog.getPlantsForSelectedRegion()
    }
    
    func addToCart(plant: Plant, quantity: Int) -> Bool {
        let totalCost = plant.price * Double(quantity)
        
        if Double(coinsManager.totalCoins) < totalCost {
            return false
        }
        
        if let index = cartItems.firstIndex(where: { $0.plant.id == plant.id }) {
            cartItems[index].quantity += quantity
        } else {
            cartItems.append(CartItem(plant: plant, quantity: quantity))
        }
        
        return true
    }
    
    func removeFromCart(at indexSet: IndexSet) {
        cartItems.remove(atOffsets: indexSet)
    }
    
    var total: Double {
        cartItems.reduce(0) { $0 + ($1.plant.price * Double($1.quantity)) }
    }
    
    func checkout() -> Bool {
        let totalCost = total
        
        if Double(coinsManager.totalCoins) < totalCost {
            return false
        }
        
        let success = coinsManager.spendCoins(Int(totalCost), reason: "Purchased plants from shop")
        
        if success {
            for item in cartItems {
                inventoryManager.addItem(plant: item.plant, quantity: item.quantity)
            }
            
            cartItems = []
            showingCart = false
            showCheckoutSuccess = true
            hasMadePurchase = true
            
            return true
        }
        
        return false
    }
}

struct ShoppingView: View {
    @ObservedObject private var coinsManager = CoinsManager.shared
    @ObservedObject private var inventoryManager = InventoryManager.shared
    @StateObject private var viewModel = ShoppingViewModel()
    @State private var searchText = ""
    @State private var navigateToFarming = false
    @State private var showCategoryFilter = false
    @State private var selectedCategory: String? = nil
    
    var filteredPlants: [Plant] {
        var plants = viewModel.availablePlants
        
        if !searchText.isEmpty {
            plants = plants.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let category = selectedCategory {
            plants = plants.filter { $0.category == category }
        }
        
        return plants
    }
    
    var availableCategories: [String] {
        let categories = Set(viewModel.availablePlants.map { $0.category })
        return Array(categories).sorted()
    }
    
    var body: some View {
        ZStack {
            Color(red: 205/255, green: 230/255, blue: 245/255)
                            .edgesIgnoringSafeArea(.all)
            VStack {
                if let region = PlantCatalog.shared.getSelectedRegion() {
                    HStack {
                        Text("Region: \(region)")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                        
                        Spacer()
                        
                        Button(action: {
                            showCategoryFilter.toggle()
                        }) {
                            HStack {
                                Text(selectedCategory ?? "All Categories")
                                    .font(.subheadline)
                                
                                Image(systemName: "chevron.down")
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    if showCategoryFilter {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                Button(action: {
                                    selectedCategory = nil
                                    showCategoryFilter = false
                                }) {
                                    Text("All")
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(selectedCategory == nil ? Color.green : Color.green.opacity(0.2))
                                        .foregroundColor(selectedCategory == nil ? .white : .primary)
                                        .cornerRadius(10)
                                }
                                
                                ForEach(availableCategories, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        showCategoryFilter = false
                                    }) {
                                        Text(category)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                            .background(selectedCategory == category ? Color.green : Color.green.opacity(0.2))
                                            .foregroundColor(selectedCategory == category ? .white : .primary)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 5)
                    }
                }
                
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
                
                if filteredPlants.isEmpty {
                    Spacer()
                    VStack(spacing: 10) {
                        Image(systemName: "leaf.arrow.triangle.circlepath")
                            .font(.system(size: 50))
                            .foregroundColor(.green.opacity(0.7))
                        
                        Text("No plants found")
                            .font(.headline)
                        
                        Text("Try a different search or category")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
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
            }
            
            overlayViews
            
            NavigationLink("", destination: FarmMapView(), isActive: $navigateToFarming)
                .hidden()
        }
        .navigationTitle("Plant Shop")
        .toolbar {
            toolbarContent
        }
    }
    
    @ViewBuilder
    private var overlayViews: some View {
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
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
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
        
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    
                    Text("\(coinsManager.totalCoins)")
                        .fontWeight(.bold)
                }
                
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

struct ShoppingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShoppingView()
        }
    }
}
