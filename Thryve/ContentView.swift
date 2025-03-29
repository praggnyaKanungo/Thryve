import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image("welcome") // Make sure the image name matches your asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200, alignment: .center)
                
                Text("Welcome to Thryve!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Start your sustainable farming journey and grow with our community.")
                    .padding()

                // Button and Navigation Link
                NavigationLink(destination: MissionView()) {
                    Text("Start Farming")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .navigationBarHidden(true) // Hide navigation bar here
        }
    }
}

struct MissionView: View {
    var body: some View {
        VStack {
            Text("Mission & User Agreements")
                .font(.title)
                .padding()
            
            ScrollView {
                Text("Here you can add the details for your mission and user agreements...")
                    .padding()
            }
        }
        .navigationTitle("Mission & User Agreements") // Set navigation title here
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
