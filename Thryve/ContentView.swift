import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("welcome") // Ensure this image is in your asset catalog
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Welcome to Thryve!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding()
                    
                    Text("Start your sustainable farming journey and grow with our community.")
                        .foregroundColor(.green)
                        .padding()
                    
                    NavigationLink(destination: MissionView()) {
                        Text("Start Farming")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}


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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
