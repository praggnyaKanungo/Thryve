import SwiftUI

struct PickCountry: View {
    var selectedCountry: String // Passed from the map
    @State private var selectedLandSize = "small"
    @State private var navigateToShopping = false
    let landSizes = ["small", "medium", "large"]

    var body: some View {
        VStack {
            Text("Select options for \(selectedCountry)")
                .font(.headline)
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
