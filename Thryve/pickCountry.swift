import SwiftUI

struct pickCountry: View {
    @State private var selectedCountry = "USA"
    @State private var selectedLandSize = "small"
    let countries = ["USA", "Canada", "Mexico", "Brazil", "UK"]
    let landSizes = ["small", "medium", "large"]

    // Computed property to determine the budget based on land size
    var budget: Int {
        switch selectedLandSize {
        case "small":
            return 1000
        case "medium":
            return 5000
        case "large":
            return 10000
        default:
            return 1000  // Default case to handle unexpected values
        }
    }

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

            // Display the budget based on the selected land size
            Text("Budget: $\(budget)")
                .padding()

            Button("Submit") {
                // Handle the submission logic here
                print("Submission Confirmed with budget of $\(budget)")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .padding()
        }
    }
}
