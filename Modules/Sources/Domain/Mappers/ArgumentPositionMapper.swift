//
//  ArgumentPositionMapper.swift
//
//
//  Created by Vadim Marchenko on 13.03.2024.
//

import Foundation
import Data

extension ArgumentPosition {
    func mapToData() -> ArgumentPositionEntity {
        guard let position = ArgumentPositionEntity(rawValue: self.rawValue) else {
            fatalError("Could not map")
        }
        return position
    }
}

extension ArgumentPositionEntity {
    func mapToDomain() -> ArgumentPosition {
        guard let position = ArgumentPosition(rawValue: self.rawValue) else {
            fatalError("Could not map")
        }
        return position
    }
}
