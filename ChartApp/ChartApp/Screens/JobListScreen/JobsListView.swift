//
//  JobsListView.swift
//  iOSDashboardAssessment
//
//  Created by Thangarajan on 13/03/25.
//

import SwiftUI
import SampleData


struct JobsListView: View {
    @ObservedObject var viewModel: DashboardViewModel
    let type: CardSelect
    
    var body: some View {
        let total: String = type == .job ? "\(viewModel.totalJobs) Jobs" : "Total value ($\(viewModel.totalInvoiceValue))"
        let completed: String = type == .job ? "\(viewModel.completedJobs) of \(viewModel.totalJobs) completed" : "$\(viewModel.collectedAmount) Collected"
        let navi: String = type == .job ? "Jobs (\(viewModel.totalJobs))" : "Total value ($\(viewModel.totalInvoiceValue))"
        
        VStack {
            // Header
            HStack {
                Text(total)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text(completed)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // Progress View
            MultiColorProgressView(
                values: type == .job ? viewModel.jobStateItems.values.map { CGFloat($0.count) } : viewModel.invoiceStatItems.values.map { CGFloat($0.value) },
                colors: type == .job ? viewModel.jobStateItems.values.map { $0.color } : viewModel.invoiceStatItems.values.map { $0.color }
            )
            .padding(.horizontal)
            Divider()
            
            // Status Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    if type == .job {
                        ForEach(JobStatus.allCases, id: \.self) { item in
                            let count = viewModel.jobStateItems[item]?.count ?? 0
                            
                            VStack(spacing: 4) {
                                Text("\(item.toString()) (\(count))")
                                    .foregroundColor(viewModel.selectedJobStatus == item ? .blue : .black)
                                    .padding(.vertical, 8)
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(viewModel.selectedJobStatus == item ? .blue : .clear)
                            }
                            .onTapGesture {
                                viewModel.selectedJobStatus = item
                                viewModel.updateFilteredJobs()
                            }
                        }
                    } else if type == .invoice {
                        ForEach(InvoiceStatus.allCases, id: \.self) { item in
                            let count = viewModel.invoiceStatItems[item]?.value ?? 0
                            
                            VStack(spacing: 4) {
                                Text("\(item.toString()) (\(count))")
                                    .foregroundColor(viewModel.selectedInvoiceStatus == item ? .blue : .black)
                                    .padding(.vertical, 8)
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(viewModel.selectedInvoiceStatus == item ? .blue : .clear)
                            }
                            .onTapGesture {
                                viewModel.selectedInvoiceStatus = item
                                viewModel.updateInvoiceStats()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 55)
            if type == .job {
                List(viewModel.filteredJobs, id: \.jobNumber) { job in
                    VStack(alignment: .leading) {
                        Text("#\(job.jobNumber)")
                            .font(.subheadline)
                        Text(job.title)
                            .font(.headline)
                        Text(formatTimeRange(startTime: job.startTime, endTime: job.endTime))
                           
                            .foregroundColor(.gray)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.fetchData()
                }
            } else if type == .invoice {
                List(viewModel.filteredInvoices, id: \.invoiceNumber) { invoi in
                    VStack(alignment: .leading) {
                        Text("#\(invoi.invoiceNumber)")
                            .font(.subheadline)
                        Text(invoi.customerName)
                            .font(.headline)
                        Text("$\(invoi.total)")
                            .foregroundColor(.gray)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.fetchData()
                }
            }
            
            
        }
        .navigationTitle(navi)
        .font(.subheadline)
        .padding()
    }
    
    func formatTimeRange(startTime: String, endTime: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        outputFormatter.timeZone = TimeZone.current
        
        if let startDate = inputFormatter.date(from: startTime),
           let endDate = inputFormatter.date(from: endTime) {
            
            let startString = outputFormatter.string(from: startDate)
            let endString = outputFormatter.string(from: endDate)
            
            return "\(startString) - \(endString)"
        } else {
            return "Invalid Time"
        }
    }

}
