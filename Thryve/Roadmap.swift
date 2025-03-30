import SwiftUI

struct RoadMapView: View {
    @State private var selectedRegion: String? 
    @State private var backgroundImage = "newBackground" 
    @State private var navigateToCountryPicker = false 
    
    // Dictionary of region details (Native Plants & Description)
    let regionDetails: [String: (location: String, plants: String, description: String, position: (x: CGFloat, y: CGFloat))] = [
        "Australia": ("New South Wales, Australia", "Apples, Grapes", "This area contains river valleys, plains, and granite outcrops. It is a diverse landscape.", (170, -140)),
        "North America": ("Des Moines, Iowa, USA","Corn, Soybeans", "Most of the landscape consists of rolling hills and wetlands with average temperatures of 43 degrees farenheit.", (-160, -250)),
        "South America": ("La Pampa, Argentina", "Wheat, Sorghum", "Most of the landscape contains flat plains with the soil being composed of sand, clay, and silt.", (-100, -150)),
        "East Asia": ("Mongolia, China, Asia", "Sugar Beets, Oilseeds", "This is mainly grassland and has a harsh climate. Many storms go through this area so crops need to be able to survive harsh conditions.", (140, -260)),
        "South Asia": ("Rajasthan, India, Asia","Rice, Millets", "This area sits on a broad plateu and further in the north. The land levels intoo flat plains. near this area are several rivers for watering.", (90, -220)),
        "Europe": ("Saratov, Russia", "Barley, Oats", "Most of the landscape contains river valleys, erosion gullies, and rolling plains, It has a dry climate but fertile soil.", (5, -270)),
        "Africa": ("Uganda, Africa","Sweet Potatoes, Beans", "Uganda sits on a plateau surrounded by mountains and valleys. It contains short grass areas with dry soil.", (15, -175))
    ]

    var body: some View {
        ZStack {
            Image(backgroundImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
            
            ForEach(regionDetails.keys.sorted(), id: \.self) { region in
                if let details = regionDetails[region] {
                    Button(action: {
                        self.selectedRegion = region 
                    }) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text(region)
                                .foregroundColor(.blue)
                        }
                    }
                    .offset(x: details.position.0, y: details.position.1)
                }
            }

            if let region = selectedRegion, let details = regionDetails[region] {
                VStack {
                    Text(details.location)
                        .font(.title)
                        .bold()
                    Text("Native Plants: \(details.plants)")
                        .font(.headline)
                        .padding(.top, 5)
                    Text(details.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button("Use this region") {
                        AppStateManager.shared.resetAppState()
                        self.navigateToCountryPicker = true
                    }
                    .font(.title2)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .frame(maxWidth: 300)
                    .transition(.scale)
                    .offset(y: 165)
            }

            NavigationLink(
                destination: PickCountry(selectedCountry: selectedRegion ?? ""),
                isActive: $navigateToCountryPicker
            ) { EmptyView() }
        }
        .navigationBarTitle("Select a Region", displayMode: .inline)
    }
}
