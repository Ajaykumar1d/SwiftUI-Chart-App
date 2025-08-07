//
//  Dashboard.swift
//  iOSDashboardAssessment
//
//  Created by Thangarajan on 12/03/25.
//

import SwiftUI



struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ProfileCardView()
                    NavigationLink(destination: JobsListView(viewModel: viewModel, type: .job)) {
                        CardCell(viewModel: viewModel, type: .job)
                    }
                    .buttonStyle(PlainButtonStyle())
                    NavigationLink(destination: JobsListView(viewModel: viewModel, type: .invoice)) {
                        CardCell(viewModel: viewModel, type: .invoice)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}
