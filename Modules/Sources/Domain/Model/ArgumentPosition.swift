//
//  ArgumentPosition.swift
//  
//
//  Created by Vadim Marchenko on 11.03.2024.
//

import Foundation

public enum ArgumentPosition: Int {
    case pros
    case cons
    case unowned

    public var titleKey: String {
        switch self {
        case .pros:
            return "pros"
        case .cons:
            return "cons"
        case .unowned:
            return ""
        }
    }

    public var emoji: String {
        switch self {
        case .cons:
            return "⛔"
        case .pros:
            return "✅"
        case .unowned:
            return ""
        }
    }
}
