//
//  DashboardModel.swift
//  iOSDashboardAssessment
//
//  Created by Thangarajan on 12/03/25.
//

import Foundation
import SwiftUI


struct JobStat: Identifiable, Hashable {
    var id = UUID()
    var status: String
    var count: Int
    var color: Color
}

struct InvoiceStat: Identifiable, Hashable {
    var id = UUID()
    var status: String
    var value: Int
    var color: Color
}
