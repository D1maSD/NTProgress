//
//  BottomSheetViewModel.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 29.01.2024.
//

import Foundation

public enum BottomSheetCellType {
    case price
    case amount
    case name
    case date
    case side

    var title: String {
        switch self {
        case .price:
            return "По цене"
        case .amount:
            return "По количеству"
        case .name:
            return "По имени"
        case .date:
            return "По дате"
        case .side:
            return "По стороне"
        }
    }
}

public struct BottomSheetViewModel: Equatable {

    let title: String
    let type: BottomSheetCellType
    var isSelected: Bool

    init(type: BottomSheetCellType, isSelected: Bool) {
        self.type = type
        self.isSelected = isSelected
        self.title = type.title
    }
}
