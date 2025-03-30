import SwiftUI

struct RoadMapView: View {
    @State private var backgroundImage = "worldmap" // Initial background image
    @State private var selectedRegion: String? // Tracks the selected region
    @State private var navigateToCountryPicker = false // Controls navigation

    var body: some View {
        ZStack {
            Image(backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)

            // Pins for each region
            pinView(region: "Australia", imageName: "AustraliaImage")
                .offset(x: +150, y: -120)
            pinView(region: "North America", imageName: "NorthAmericaImage")
                .offset(x: -160, y: -250)
            pinView(region: "South America", imageName: "SouthAmericaImage")
                .offset(x: -125, y: -150)
            pinView(region: "East Asia", imageName: "EastAsiaImage")
                .offset(x: +135, y: -250)
            pinView(region: "South Asia", imageName: "SouthAsiaImage")
                .offset(x: +60, y: -200)
            pinView(region: "Europe", imageName: "EuropeImage")
                .offset(x: -25, y: -250)
            pinView(region: "Africa", imageName: "AfricaImage")
                .offset(x: -30, y: -175)

            // Instructional text card, visible only when no region is selected
            if selectedRegion == nil {
                instructionalCard
                    .transition(.move(edge: .bottom))
                    .centerHorizontally() // Center in the view
            }

            // "Use this region" button, shown only after a region is selected
            if let region = selectedRegion {
                Button("Use this region") {
                    // Reset the app state before proceeding to a new region
                    AppStateManager.shared.resetAppState()
                    self.navigateToCountryPicker = true
                }
                .font(.title)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .transition(.scale)
                .centerHorizontally() // Center in the view
            }

            // Navigation link to navigate to PickCountry
            NavigationLink(
                destination: PickCountry(selectedCountry: selectedRegion ?? ""),
                isActive: $navigateToCountryPicker
            ) { EmptyView() }
        }
        .navigationBarTitle("Select a Region", displayMode: .inline)
    }

    @ViewBuilder
    private func pinView(region: String, imageName: String) -> some View {
        Button(action: {
            self.backgroundImage = imageName // Update the background image
            self.selectedRegion = region // Update the selected region
        }) {
            VStack {
                Image(systemName: "mappin.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                Text(region)
                    .foregroundColor(.blue)
            }
        }
    }

    // Instructional Card View
    private var instructionalCard: some View {
        Text("Please tap on each region to learn about what you can plant there so you can make your choice of location!")
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.8))
            .cornerRadius(15)
            .padding()
    }
}

// Helper extension to center views horizontally and vertically
extension View {
    func centerHorizontally() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
