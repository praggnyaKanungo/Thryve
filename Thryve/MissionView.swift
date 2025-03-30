import SwiftUI
import PDFKit

struct MissionView: View {
    @State private var isAgreed = false
    @State private var shouldNavigate = false

    let pdfURL = Bundle.main.url(forResource: "terms_and_conditions", withExtension: "pdf")!

    var body: some View {
        VStack {
            Text("Mission & User Agreements")
                .font(.title)
                .padding()

            PDFViewer(pdfURL: pdfURL)
                .frame(height: 500) 
                .padding()

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

struct PDFViewer: UIViewRepresentable {
    var pdfURL: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
