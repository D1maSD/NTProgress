//
//  BottomSheetTableViewCell.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 29.01.2024.
//

import UIKit
import SnapKit

final class BottomSheetTableViewCell: UITableViewCell {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    private lazy var selectImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Checkmark")?.withRenderingMode(.alwaysTemplate)
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }

    func setup(viewModel: BottomSheetViewModel) {
        self.label.text = viewModel.title
        selectImage.tintColor = viewModel.isSelected ? .mustard : .inactiveCheckMarkGray
    }

    private func setupConstraint() {
        contentView.addSubview(label)
        contentView.addSubview(selectImage)

        label.snp.makeConstraints { make in
            make.leading.equalTo(11)
            make.height.equalTo(43)
            make.centerY.equalToSuperview()
        }

        selectImage.snp.makeConstraints { make in
            make.trailing.equalTo(-13)
            make.height.equalTo(28)
            make.width.equalTo(28)
            make.top.equalToSuperview().offset(11)
            make.bottom.equalToSuperview().offset(-11)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

