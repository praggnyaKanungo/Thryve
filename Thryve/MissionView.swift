import SwiftUI
import PDFKit

struct MissionView: View {
    @State private var isAgreed = false
    @State private var shouldNavigate = false

    let pdfURL = Bundle.main.url(forResource: "terms_and_conditions", withExtension: "pdf")!

    var body: some View {
        ZStack {
            Color(red: 205/255, green: 230/255, blue: 245/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Spacer()
                    .frame(height: 25)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Our Mission")
                        .font(.custom("Avenir-Heavy", size: 20))
                        .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                    
                    Text("Thryve encourages sustainability through a peaceful gaming experience that teaches you to grow crops and make the world more sustainable. We prepare you for your own farming adventures in reality, while our sponsors donate to climate action charities for each successful harvest season you complete.")
                        .font(.custom("Avenir-Book", size: 15))
                        .foregroundColor(Color(red: 60/255, green: 60/255, blue: 60/255))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.8))
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                
                PDFViewer(pdfURL: pdfURL)
                    .frame(height: 440)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .padding(.horizontal, 20)

                Spacer()

                Toggle("I have read all the terms and conditions", isOn: $isAgreed)
                    .font(.custom("Avenir-Medium", size: 16))
                    .foregroundColor(Color(red: 50/255, green: 50/255, blue: 50/255))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 76/255, green: 175/255, blue: 80/255)))

                Button("I Agree") {
                    if isAgreed {
                        shouldNavigate = true
                    }
                }
                .font(.custom("Avenir-Heavy", size: 18))
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .padding(.horizontal, 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(isAgreed ? Color(red: 76/255, green: 175/255, blue: 80/255) : Color(red: 160/255, green: 160/255, blue: 160/255))
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                .disabled(!isAgreed)
                .padding(.top, 5)
                .padding(.bottom, 30)

                NavigationLink(destination: RoadMapView(), isActive: $shouldNavigate) { EmptyView() }
            }
        }
        .navigationBarTitle("Mission & User Agreements", displayMode: .inline)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PDFViewer: UIViewRepresentable {
    var pdfURL: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .white
        
        pdfView.layer.cornerRadius = 12
        pdfView.layer.masksToBounds = true
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
