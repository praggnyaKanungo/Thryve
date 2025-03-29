//
//  pickCountry.swift
//  Thryve
//
//  Created by Praggnya Kanungo on 3/29/25.
//

import SwiftUI

struct pickCountry: View {
    @State private var selectedCountry = "USA"
    @State private var selectedLandSize = "small"
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
                ForEach(landSizes, id: \.self) { sizes in
                    Text(sizes)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Text("Budget: $1000")
                .padding()

            Button("Submit") {
                // Handle the submission logic here
                print("Submission Confirmed")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .padding()
        }
    }
}
