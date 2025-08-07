//
//  CreateSampleData.swift
//  iOSDashboardAssessment
//
//  Created by Thangarajan on 12/03/25.
//

import Foundation
import SampleData



class CreateSampleData {
    func fetchJobStats() -> [JobStat] {
        let jobs = SampleData.generateRandomJobList(size: 60)
        return jobs.map { job in
            JobStat(
                status: job.status.toString(),
                count: 1,
                color: job.status.color
            )
        }
    }

    func fetchInvoiceStats() -> [InvoiceStat] {
        let invoices = SampleData.generateRandomInvoiceList(size: 60)
        return invoices.map { invoice in
            InvoiceStat(
                status: invoice.status.toString(),
                value: invoice.total,
                color: invoice.status.color
            )
        }
    }
}
