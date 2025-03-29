import SwiftUI

struct pickCountry: View {
    @State private var selectedCountry = "USA"
    @State private var selectedLandSize = "small"
    @State private var navigateToShopping = false
    let countries = ["USA", "Canada", "Mexico", "Brazil", "UK"]
    let landSizes = ["small", "medium", "large"]

    var body: some View {
        VStack {
            Text("Select your countries")
                .font(.headline)
                .padding()

            Picker("Country", selection: $selectedCountry) {
                ForEach(countries, id: \.self) { country in
                    Text(country)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Picker("Land Size", selection: $selectedLandSize) {
                ForEach(landSizes, id: \.self) { size in
                    Text(size)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Text("Budget: $\(budget(for: selectedLandSize))")
                .padding()

            Button("Submit") {
                navigateToShopping = true
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .padding()

            NavigationLink("", destination: ShoppingView(), isActive: $navigateToShopping)
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
