//
//  TypeExtensions.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 28.01.2024.
//

import Foundation

extension Double {
    func rounded(toDecimalPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
    func isEqual(to value: Double, epsilon: Double = .ulpOfOne.squareRoot()) -> Bool {
        return abs(self - value) < epsilon
    }
}
