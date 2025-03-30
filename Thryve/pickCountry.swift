import SwiftUI

struct PickCountry: View {
    var selectedCountry: String // Passed from the map
    @State private var selectedLandSize = "small"
    @State private var navigateToShopping = false
    let landSizes = ["small", "medium", "large"]

    // Reference to CoinsManager
    @ObservedObject private var coinsManager = CoinsManager.shared
    
    // Get background image based on selected country
    private var backgroundImageName: String {
        switch selectedCountry {
        case "Australia":
            return "australiaBackground"
        case "North America":
            return "northAmericaBackground"
        case "South America":
            return "southAmericaBackground"
        case "East Asia":
            return "eastAsiaBackground"
        case "South Asia":
            return "southAsiaBackground"
        case "Europe":
            return "europeBackground"
        case "Africa":
            return "africaBackground"
        default:
            return "defaultBackground" // Fallback background
        }
    }
    
    var body: some View {
        ZStack {
            // Background image based on selected country
            Image(backgroundImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            // Semi-transparent overlay for better text readability
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                // Header with country name
                Text("Farm in \(selectedCountry)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                
                Spacer()
                Spacer()
                Spacer() // Added extra spacers to push content further down
                Spacer()
                
                // Content card
                VStack(spacing: 20) {
                    Text("Choose your farm size")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Land size picker with custom styling
                    Picker("Land Size", selection: $selectedLandSize) {
                        ForEach(landSizes, id: \.self) { size in
                            Text(size.capitalized)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    
                    // Visualize the farm size
                    farmSizeVisualizer(for: selectedLandSize)
                        .frame(height: 100)
                        .padding(.vertical)
                    
                    // Budget display
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        
                        Text("Starting Budget: $\(budget(for: selectedLandSize))")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(12)
                    
                    // Submit button
                    Button(action: {
                        coinsManager.totalCoins = budget(for: selectedLandSize)
                        navigateToShopping = true
                    }) {
                        Text("Start Farming")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 40)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.green.opacity(0.7)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    .padding(.bottom, 30)
                }
                .padding(30)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.bottom, 60) // Increased bottom padding
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5, alignment: .bottom) // Constrain to bottom 50% of screen
                
                Spacer()
                Spacer() // Added another spacer at the bottom
            }
            
            NavigationLink("", destination: ShoppingView(), isActive: $navigateToShopping)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    // Visual representation of farm size
    @ViewBuilder
    private func farmSizeVisualizer(for size: String) -> some View {
        HStack(spacing: 5) {
            switch size {
            case "small":
                Rectangle()
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
            case "medium":
                ForEach(0..<2, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.green.opacity(0.7))
                        .frame(width: 80, height: 80)
                        .cornerRadius(5)
                }
            case "large":
                ForEach(0..<3, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.green.opacity(0.7))
                        .frame(width: 80, height: 80)
                        .cornerRadius(5)
                }
            default:
                Rectangle()
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
            }
        }
    }

    private func budget(for landSize: String) -> Int {
        switch landSize {
        case "small":
            return 1000
        case "medium":
            return 5000
        case "large":
            return 10000
        default:
            return 1000
        }
    }
}
