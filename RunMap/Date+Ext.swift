//
//  Date+Ext.swift
//  RunMap
//
//  Created by Aisha on 18.02.25.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}
