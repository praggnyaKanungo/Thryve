import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("welcome")
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
