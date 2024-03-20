//
//  FibonacciPriority.swift
//
//
//  Created by Vadim Marchenko on 20.03.2024.
//

import Foundation

public enum FibonacciPriority: Int, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3
    case extreme = 5
    case highest = 8

    var title: String {
        var title = ""
        switch self {
        case .low: title = "Low".localized
        case .medium:
            title = "Medium".localized
        case .high:
            title = "High".localized
        case .extreme:
            title = "Extreme".localized
        case .highest:
            title = "Highest".localized
        }
        return "\(title) - \(self())"
    }

    func callAsFunction() -> Int {
        return self.rawValue
    }
}
