//
//  String+.swift
//
//
//  Created by Vadim Marchenko on 08.03.2024.
//

import Foundation

public extension String {
    var localized: String {
        let bundle = Bundle.module
        return NSLocalizedString(self, bundle: bundle, comment: "\(self)_comment")
    }
}
