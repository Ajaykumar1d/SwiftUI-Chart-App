//
//  CardView.swift
//  iOSDashboardAssessment
//
//  Created by Thangarajan on 12/03/25.
//

import SwiftUI

enum CardSelect {
    case job
    case invoice
}

struct ProfileCardView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello, Henry Jones! 👋")
                    .font(.headline)
                Text(todayDate())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray6), lineWidth: 1.5)
        )
    }
    
    private func todayDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
}


struct CardCell: View {
    @ObservedObject var viewModel: DashboardViewModel
    let type: CardSelect
    
    var body: some View {
        
        let cardName:String = type == .job ? "Job Stats" : "Invoice State"
        let total:String = type == .job ? "\(viewModel.totalJobs) Jobs" : "Total value ($\(viewModel.totalInvoiceValue))"
        let completed:String = type == .job ? "\(viewModel.completedJobs) of \(viewModel.totalJobs) completed" : "$\(viewModel.collectedAmount) Collected"
               
        
        VStack(alignment: .leading, spacing: 10) {
            Text(cardName)
            Divider()
            HStack {
                Text(total)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text(completed)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            MultiColorProgressView(
                values: type == .job ? viewModel.jobStateItems.values.map { CGFloat($0.count) } : viewModel.invoiceStatItems.values.map{CGFloat($0.value)},
                colors: type == .job ? viewModel.jobStateItems.values.map { $0.color } : viewModel.invoiceStatItems.values.map { $0.color }
            )
            
            HStack{
                FlowLayout {
                    if type == .job {
                        ForEach(Array(viewModel.jobStateItems.values), id: \.id) { item in
                            HStack(spacing: 4) {
                                Rectangle()
                                    .fill(item.color)
                                    .frame(width: 12, height: 12)

                                Text("\(item.status) (\(item.count))")
                                    .font(.subheadline)
                                    .padding(.vertical, 6)
                            }
                            .padding(.horizontal, 4)
                        }
                    } else {
                        
                        ForEach(Array(viewModel.invoiceStatItems.values), id: \.id) { item in
                            HStack(spacing: 4) {
                                Rectangle()
                                    .fill(item.color)
                                    .frame(width: 12, height: 12)

                                Text("\(item.status) ($\(item.value))")
                                    .font(.subheadline)
                                    .padding(.vertical, 6)
                            }
                            .padding(.horizontal, 4)
                        }
                        
                        
                    }
                }
                Spacer()

            }
            .padding(.vertical,12)
            

        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray6), lineWidth: 1.5)
        )
    }
}


struct MultiColorProgressView: View {
    let values: [CGFloat]
    let colors: [Color]

    var body: some View {
        let total = values.reduce(0, +)
        let adjustedTotal = max(total, 1)
        let sortedData = zip(values, colors)
            .sorted { $0.0 > $1.0 }

        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0..<sortedData.count, id: \.self) { index in
                    Rectangle()
                        .fill(sortedData[index].1)
                        .frame(width: geometry.size.width * (sortedData[index].0 / adjustedTotal))
                }
            }
        }
        .frame(height: 20)
        .cornerRadius(8)
    }
}
