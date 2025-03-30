import SwiftUI

// Cloud effect
struct CloudEffect: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<5) { i in
                Image(systemName: "cloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: CGFloat.random(in: 50...100))
                    .foregroundColor(.white.opacity(0.7))
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height/3)
                    )
            }
        }
        .allowsHitTesting(false)
    }
}

// Rain effect
struct RainEffect: View {
    var body: some View {
        ZStack {
            // Cloud cover
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .edgesIgnoringSafeArea(.all)
            
            // Rain drops
            GeometryReader { geometry in
                ForEach(0..<40) { i in
                    RainDrop()
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// Rain drop
struct RainDrop: View {
    @State private var falling = false
    
    var body: some View {
        Circle()
            .fill(Color.blue.opacity(0.6))
            .frame(width: 3, height: 10)
            .scaleEffect(y: 2)
            .offset(y: falling ? 500 : 0)
            .opacity(falling ? 0 : 0.7)
            .animation(
                Animation.linear(duration: Double.random(in: 0.8...1.5))
                    .repeatForever(autoreverses: false),
                value: falling
            )
            .onAppear {
                falling = true
            }
    }
}

// Storm effect
struct StormEffect: View {
    @State private var flash = false
    
    var body: some View {
        ZStack {
            // Darker cloud cover
            Rectangle()
                .fill(Color.blue.opacity(0.2))
                .edgesIgnoringSafeArea(.all)
            
            // Lightning flash
            Rectangle()
                .fill(Color.white)
                .opacity(flash ? 0.3 : 0)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    withAnimation(Animation.easeOut(duration: 0.2).repeatForever(autoreverses: true).delay(Double.random(in: 3...10))) {
                        flash.toggle()
                    }
                }
            
            // Heavy rain
            RainEffect()
        }
        .allowsHitTesting(false)
    }
}

// Hot effect
struct HotEffect: View {
    @State private var waving = false
    
    var body: some View {
        ZStack {
            // Warm overlay
            Rectangle()
                .fill(Color.orange.opacity(0.2))
                .edgesIgnoringSafeArea(.all)
            
            // Heat waves
            GeometryReader { geometry in
                ForEach(0..<8) { i in
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let yOffset = CGFloat(i) * height / 8
                        
                        path.move(to: CGPoint(x: 0, y: yOffset))
                        
                        // Create wavy line
                        for x in stride(from: 0, to: width, by: 10) {
                            let sine = sin(Double(x) / 30 + Double(i) + (waving ? 10 : 0))
                            let y = yOffset + CGFloat(sine * 5)
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                }
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                    waving.toggle()
                }
            }
        }
        .allowsHitTesting(false)
    }
}
