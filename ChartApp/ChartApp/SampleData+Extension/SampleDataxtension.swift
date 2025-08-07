//
//  File.swift
//  iOSDashboardAssessment
//
//  Created by Thangarajan on 12/03/25.
//

import Foundation
import SampleData
import SwiftUI


extension JobStatus {
    func toString() -> String {
        switch self {
        case .yetToStart: return Strings.yetToStart
        case .inProgress: return Strings.progres
        case .canceled: return Strings.cancel
        case .completed: return Strings.complet
        case .incomplete: return Strings.inComplet
        }
    }
    
    var color: Color {
        switch self {
        case .yetToStart: return .orange
        case .inProgress: return .blue
        case .canceled: return .yellow
        case .completed: return .green
        case .incomplete: return .red
        }
    }
}

extension InvoiceStatus {
    func toString() -> String {
        switch self {
        case .draft: return Strings.draft
        case .pending: return Strings.pending
        case .paid: return Strings.paid
        case .badDebt: return Strings.baddebt
        }
    }
    
    var color: Color {
        switch self {
        case .draft: return .yellow
        case .pending: return .blue
        case .paid: return .green
        case .badDebt: return .red
        }
    }
}
