//
//  MissionView.swift
//  Thryve
//
//  Created by Praggnya Kanungo on 3/29/25.
//
import SwiftUI

struct MissionView: View {
    @State private var isAgreed = false
    @State private var shouldNavigate = false

    var body: some View {
        VStack {
            Text("Mission & User Agreements")
                .font(.title)
                .padding()

            ScrollView {
                Text("Here you can add the details for your mission and user agreements...")
                    .padding()
            }

            Spacer()

            Toggle("I have read all the terms and conditions", isOn: $isAgreed)
                .padding()
                .toggleStyle(SwitchToggleStyle(tint: .green))

            Button("I Agree") {
                if isAgreed {
                    shouldNavigate = true
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(isAgreed ? Color.blue : Color.gray)
            .cornerRadius(10)
            .disabled(!isAgreed)

            NavigationLink(destination: RoadMapView(), isActive: $shouldNavigate) { EmptyView() }

            Spacer()
        }
        .navigationBarTitle("Mission & User Agreements", displayMode: .inline)
    }
}
