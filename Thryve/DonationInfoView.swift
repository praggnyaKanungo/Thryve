


import SwiftUI

// Donation info view
struct DonationInfoView: View {
    @ObservedObject var farmManager = FarmMapManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.red)
                
                Text("Plant for Change")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("For every 10 successful harvests, we donate $10 to the Green Earth Foundation to support reforestation efforts.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Progress to next donation
                VStack {
                    Text("Progress to next donation:")
                        .font(.headline)
                    
                    HStack {
                        Text("0")
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 20)
                                .cornerRadius(10)
                            
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: CGFloat(min(farmManager.totalSuccessfulHarvests % 10, 10)) / 10.0 * 250, height: 20)
                                .cornerRadius(10)
                        }
                        .frame(width: 250)
                        
                        Text("10")
                    }
                }
                .padding()
                
                Text("Total Donations: $\(farmManager.donations.count * 10)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                if !farmManager.donations.isEmpty {
                    List {
                        ForEach(farmManager.donations) { donation in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("$\(donation.amount) to \(donation.organization)")
                                        .fontWeight(.medium)
                                    
                                    Text(formatDate(donation.date))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    Text("Keep harvesting to make your first donation!")
                        .italic()
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .navigationTitle("Donations")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Format date for donation history
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
