//
//  DashboardViewModel.swift
//  iOSDashboardAssessment
//
//  Created by Thangarajan on 12/03/25.
//

import Foundation
import SampleData
import SwiftUI



class DashboardViewModel: ObservableObject {
    @Published var totalJobs = 0
    @Published var completedJobs = 0
    @Published var jobStats: [JobStat] = []
    
    @Published var filteredJobs: [JobApiModel] = []
    @Published var selectedJobStatus: JobStatus = .yetToStart

    @Published var totalInvoiceValue = 0
    @Published var collectedAmount = 0
    @Published var invoiceStats: [InvoiceStat] = []
    
    @Published var filteredInvoices: [InvoiceApiModel] = []
    @Published var selectedInvoiceStatus: InvoiceStatus = .draft
    
    @Published var jobStateItems: [JobStatus: JobStat] = [:]
    @Published var invoiceStatItems: [InvoiceStatus: InvoiceStat] = [:]


    private let sampleData = CreateSampleData()

    func fetchData() {
        jobStats = sampleData.fetchJobStats()
        totalJobs = jobStats.count
        completedJobs = jobStats.filter { $0.status == "Completed" }.count

        invoiceStats = sampleData.fetchInvoiceStats()
        totalInvoiceValue = invoiceStats.reduce(0) { $0 + $1.value }
        collectedAmount = invoiceStats.first(where: { $0.status == "Paid" })?.value ?? 0

        updateFilteredJobs()
        updateJobCounts()
        updateInvoiceStats()
        updateFilteredInvoice()
        
    }
    
    func updateJobCounts() {
        jobStateItems = [
            .yetToStart: JobStat(
                status: JobStatus.yetToStart.toString(),
                count: jobStats.filter { $0.status == JobStatus.yetToStart.toString() }.count,
                color: JobStatus.yetToStart.color
            ),
            .completed: JobStat(
                status: JobStatus.completed.toString(),
                count: jobStats.filter { $0.status == JobStatus.completed.toString() }.count,
                color: JobStatus.completed.color
            ),
            .inProgress: JobStat(
                status: JobStatus.inProgress.toString(),
                count: jobStats.filter { $0.status == JobStatus.inProgress.toString() }.count,
                color: JobStatus.inProgress.color
            ),
            .canceled: JobStat(
                status: JobStatus.canceled.toString(),
                count: jobStats.filter { $0.status == JobStatus.canceled.toString() }.count,
                color: JobStatus.canceled.color
            ),
            .incomplete: JobStat(
                status: JobStatus.incomplete.toString(),
                count: jobStats.filter { $0.status == JobStatus.incomplete.toString() }.count,
                color: JobStatus.incomplete.color
            )
        ]
    }
    
    func updateInvoiceStats() {
        invoiceStatItems = [
            .draft: InvoiceStat(
                status: InvoiceStatus.draft.toString(),
                value: invoiceStats.filter { $0.status == InvoiceStatus.draft.toString() }
                    .reduce(0) { $0 + $1.value },
                color: InvoiceStatus.draft.color
            ),
            .pending: InvoiceStat(
                status: InvoiceStatus.pending.toString(),
                value: invoiceStats.filter { $0.status == InvoiceStatus.pending.toString() }
                    .reduce(0) { $0 + $1.value },
                color: InvoiceStatus.pending.color
            ),
            .paid: InvoiceStat(
                status: InvoiceStatus.paid.toString(),
                value: invoiceStats.filter { $0.status == InvoiceStatus.paid.toString() }
                    .reduce(0) { $0 + $1.value },
                color: InvoiceStatus.paid.color
            ),
            .badDebt: InvoiceStat(
                status: InvoiceStatus.badDebt.toString(),
                value: invoiceStats.filter { $0.status == InvoiceStatus.badDebt.toString() }
                    .reduce(0) { $0 + $1.value },
                color: InvoiceStatus.badDebt.color
            )
        ]
    }



    func updateFilteredJobs() {
        let jobs = SampleData.generateRandomJobList(size: 60)
        filteredJobs = jobs.filter { $0.status == selectedJobStatus }
        
    }
    func updateFilteredInvoice() {
        let jobs = SampleData.generateRandomInvoiceList(size: 60)
        filteredInvoices = jobs.filter { $0.status == selectedInvoiceStatus }
    }
}
