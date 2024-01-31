//
//  BottomSheetTwo.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 29.01.2024.
//
import UIKit
import SnapKit



protocol BottomSheetDelegate: AnyObject {
    func dismiss()
    func allParameters(data: [BottomSheetCellType], type: BottomSheetType)
    func setType(type: Bool)
}

final class BottomSheetViewController: UIViewController {

    private weak var delegate: BottomSheetDelegate?

    private var selectionType: BottomSheetSelectionType?
    private var neededHeightForContainer: CGFloat = 0
    private let confirmButton = CustomRoundedButton()
    private let tableView = TableViewFactory.make()
    private var type: BottomSheetType = .filter

    private let maxDimmedAlpha: CGFloat = 0.6
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()

    private let gestureLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .mustard
        return view
    }()

    private let typeOfSortButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("По возрастанию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    private var arrayModels: [BottomSheetViewModel] = []

    init(delegate: BottomSheetDelegate, cells: [BottomSheetCellType]) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        titleLabel.text = "Сортировать"
        setupView()
        configureTableView()
        behaviorСustomization()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }

    private func setup() {
        confirmButton.configure()
        confirmButton.addTarget(self, action: #selector(confirmTap), for: .touchUpInside)
        typeOfSortButton.addTarget(self, action: #selector(handleCloseAction), for: .touchUpInside)
        arrayModels = type.cellModels
        selectionType = .single
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellType: BottomSheetTableViewCell.self)
        tableView.reloadData()
    }

    private func setupView() {
        view.clipsToBounds = true
        setupDimmedView()
        setupContainer()
        setupConfirmButton()
        setupTableView()
        setupTitleLabel()
        setupGestureLabel()
        setupTypeOfSortButton()
    }

    private func setupDimmedView() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupContainer() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupGestureLabel() {
        containerView.addSubview(gestureLabel)
        gestureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(17)
            make.height.equalTo(3)
            make.width.equalTo(34)
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
        }
    }

    private func setupTypeOfSortButton() {
        containerView.addSubview(typeOfSortButton)
        typeOfSortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.equalTo(30)
        }
    }

    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalTo(tableView.snp.top).offset(-10)
        }
    }

    private func setupTableView() {
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(arrayModels.count * 50)
            make.bottom.equalTo(confirmButton.snp.top).offset(-11)
        }
    }

    private func setupConfirmButton() {
        containerView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(11)
            make.trailing.equalToSuperview().offset(-11)
        }
    }

    private func behaviorСustomization() {
        view.layoutIfNeeded()
        neededHeightForContainer = containerView.frame.height
        containerView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        setupPanGesture()
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }

    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.snp.updateConstraints { update in
                update.height.equalTo(height)
            }
            self.view.layoutIfNeeded()
        }
    }

    private func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.25) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.delegate?.dismiss()
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.25) {
            self.containerView.snp.updateConstraints { update in
                update.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }
    }

    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.25) {
            self.containerView.snp.updateConstraints { update in
                update.height.equalTo(self.neededHeightForContainer)
            }
            self.view.layoutIfNeeded()
        }
    }

    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    @objc private func confirmTap() {
        delegate?.allParameters(data: arrayModels.compactMap { $0.isSelected ? $0.type : nil }, type: type)
        handleCloseAction()
    }

    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = neededHeightForContainer - translation.y
        switch gesture.state {
        case .changed:
            if newHeight < neededHeightForContainer {
                self.containerView.snp.updateConstraints { update in
                    update.height.equalTo(newHeight)
                    update.bottom.equalToSuperview().offset(self.neededHeightForContainer - newHeight)
                }
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < neededHeightForContainer - 33 {
                self.animateDismissView()
            } else if newHeight < neededHeightForContainer {
                animateContainerHeight(neededHeightForContainer)
            } else if newHeight < neededHeightForContainer && isDraggingDown {
                animateContainerHeight(neededHeightForContainer)
            } else if newHeight > neededHeightForContainer && !isDraggingDown {
                animateContainerHeight(neededHeightForContainer)
            }
        default:
            break
        }
    }

    @objc private func handleCloseAction() {
        if let title = typeOfSortButton.title(for: .normal) {
                if title == "По возрастанию" {
                    typeOfSortButton.setTitle("По убыванию", for: .normal)
                    self.delegate?.setType(type: false)
                } else {
                    typeOfSortButton.setTitle("По возрастанию", for: .normal)
                    self.delegate?.setType(type: true)
                }
            }
    }

}

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BottomSheetTableViewCell.self)
        cell.setup(viewModel: arrayModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectionType = selectionType else { return }
        switch selectionType {
        case .single:
            arrayModels.enumerated().forEach { (index, item) in
                var model = item
                model.isSelected = index == indexPath.row
                arrayModels[index] = model
            }
        case .many:
            arrayModels[indexPath.row].isSelected = !arrayModels[indexPath.row].isSelected
        }
        confirmButton.updateState(isActive: arrayModels.contains(where: { model in
            model.isSelected
        }))
        tableView.reloadData()
    }
}

struct TableViewFactory {
    static func make(scrollIndicatorOff: Bool = true) -> UITableView {
        let table = UITableView(frame: .zero, style: .plain)
        if scrollIndicatorOff {
            table.showsVerticalScrollIndicator = false
            table.showsHorizontalScrollIndicator = false
        }
        return table
    }
}



