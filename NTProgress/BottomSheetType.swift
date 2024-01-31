//
//  BottomSheetType.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 29.01.2024.
//

import Foundation

enum BottomSheetSelectionType {
    case single
    case many
}

enum BottomSheetType {
    case filter


    var title: String {
        switch self {
        case .filter:
            return "Фильтр"
        }
    }

    var selectionType: BottomSheetSelectionType {
        switch self {
        case .filter:
            return .single
        }
    }

    var cellModels: [BottomSheetViewModel] {
        switch self {
        case .filter:
            return [BottomSheetViewModel(type: .side, isSelected: false),
                    BottomSheetViewModel(type: .price, isSelected: false),
                    BottomSheetViewModel(type: .amount, isSelected: false),
                    BottomSheetViewModel(type: .name, isSelected: false),
                    BottomSheetViewModel(type: .date, isSelected: false)]
        }
    }
}

