//
//  Colors.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 30.01.2024.
//

import UIKit

extension UIColor {
    static var noActivButton: UIColor { return color(hex: "E9E9E9") }
    static var mustard: UIColor { return color(hex: "#F1C249") }
    static var blackEvent: UIColor { return color(hex: "#263238") }
    static var gray: UIColor { return color(hex: "#505050") }
    static var inputTextGray: UIColor { return color(hex: "#A8A8AE")  }
    static var inputBackgroundGray: UIColor { return color(hex: "#F6F6F6") }
    static var inactiveButtonGray: UIColor { return color(hex: "#E9E9E9") }
    static var error: UIColor { return color(hex: "#FC6565") }
    static var inactiveCollectionCell: UIColor { return color(hex: "#F5F5F5") }
    static var activeCollectionell: UIColor { return color(hex: "#FFECBD") }
    static var inactiveCheckMarkGray: UIColor { return color(hex: "#EBEBEA") }
    static var toastError: UIColor { return color(hex: "#F14949") }
    static var toastNeutral: UIColor { return color(hex: "#263238") }
    static var toastSuccess: UIColor { return color(hex: "#286F6C") }
    static var backgroundBehindTheAlert: UIColor { return color(hex: "#050505") }
    static var mainBackgroundColor: UIColor { return color(hex: "#F9F9F9") }
    static var placeholderTextColor: UIColor { return color(hex: "#A5A5A5") }
    static var collectionCellGradient: UIColor { return color(hex: "#000000") }
    static var eventNonActivePagingIndicator: UIColor { return color(hex: "#FFFFFF", alpha: 0.3) }
    static var onboardingPaginationViewCommonColor: UIColor { return color(hex: "#C89105") }
    static var splashLoaderBackground: UIColor { return color(hex: "#EBEBEB") }
    static var checkedFilterButton: UIColor { return color(hex: "#FFF2D8") }
    static var createEventPlugBackground: UIColor { return color(hex: "#F1F1F1") }
    static var referalViewBackground: UIColor { return color(hex: "#FFFAEF") }
    static var unreadMessageIndicator: UIColor { return color(hex: "#EF5555") }
    static var deleteAccountAlert: UIColor { return color(hex: "#FB5656") }
    static var messageDefault: UIColor { return color(hex: "#F9F9F9") }
    static var messageHighlighted: UIColor { return color(hex: "#FFF9ED") }
    static var grayBorder: UIColor { return color(hex: "#EEEFF6") }
    static var grayTabBarBorder: UIColor { return color(hex: "#B3B3B3") }

    private static func color(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hexString: hex, alpha: alpha)
    }

    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let red   = CGFloat(Int(color >> 16) & mask) / 255.0
        let green = CGFloat(Int(color >> 8) & mask) / 255.0
        let blue = CGFloat(Int(color) & mask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

