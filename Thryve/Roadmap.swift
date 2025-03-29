//
//  Roadmap.swift
//  Thryve
//
//  Created by Praggnya Kanungo on 3/29/25.
//

import SwiftUI

struct RoadMapView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: pickCountry()) {
                    Text("Go to Country Selection")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .navigationBarTitle("Roadmap", displayMode: .inline)
        }
    }
}

