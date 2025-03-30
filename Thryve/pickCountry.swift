import SwiftUI

struct PickCountry: View {
    var selectedCountry: String 
    @State private var selectedLandSize = "small"
    @State private var navigateToShopping = false
    let landSizes = ["small", "medium", "large"]

    @ObservedObject private var coinsManager = CoinsManager.shared
    @ObservedObject private var plantCatalog = PlantCatalog.shared
    
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
            return "defaultBackground" 
        }
    }
    
    var body: some View {
        ZStack {
            Image(backgroundImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                Text("Farm in \(selectedCountry)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                
                Spacer()
                Spacer()
                Spacer() 
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Choose your farm size")
                        .font(.headline)
                        .foregroundColor(.white)
                    
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
                    
                    farmSizeVisualizer(for: selectedLandSize)
                        .frame(height: 100)
                        .padding(.vertical)
                    
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
                    
                    Button(action: {
                        plantCatalog.setRegion(selectedCountry)
                        
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
                .padding(.bottom, 60) 
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5, alignment: .bottom) 
                
                Spacer()
                Spacer() 
            }
            
            NavigationLink("", destination: ShoppingView(), isActive: $navigateToShopping)
                .hidden()
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
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
