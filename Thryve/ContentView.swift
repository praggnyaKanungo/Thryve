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
                        .font(.custom("Avenir-Heavy", size: 36))
                        .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                        .padding()
                    
                    Text("Start your sustainable farming journey and grow with our community.")
                        .font(.custom("Avenir-Book", size: 18))
                        .foregroundColor(Color(red: 60/255, green: 145/255, blue: 65/255))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination: MissionView()) {
                        Text("Start Farming")
                            .font(.custom("Avenir-Medium", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 30)
                            .background(Color(red: 106/255, green: 190/255, blue: 89/255))
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
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
