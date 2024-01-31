//
//  CustomRoundedButton.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 29.01.2024.
//

import UIKit


final class CustomRoundedButton: UIButton {
    private var isActive: Bool = false

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure() {
        setTitle("Подтвердить", for: .normal)
        layer.cornerRadius = 25
        backgroundColor = .mustard
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        titleLabel?.font = UIFont(name: "System", size: 15) // FontFamily.Montserrat.bold.font(size: 15)
        updateState(isActive: isActive)
        self.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }

    @objc private func tap() {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseIn) {
            self.alpha = 0.7
        } completion: { _ in
            self.alpha = 1
        }
    }

    func updateState(isActive: Bool) {
        self.isActive = isActive
        isEnabled = isActive
        backgroundColor = isActive ? .mustard : .inactiveCheckMarkGray
    }
}

