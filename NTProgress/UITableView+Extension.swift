//
//  UITableView+Extension.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 29.01.2024.
//

import UIKit

extension UITableView {

    func register<T: Reusable>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.identifier)
    }

    func register<T: Reusable>(cellType: T.Type, bundle: Bundle?) {
        let nib = UINib(nibName: cellType.identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: cellType.identifier)
    }


    func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self).")
        }
        return cell
    }

    func register<T: Reusable>(viewType: T.Type) {
        register(viewType.self, forHeaderFooterViewReuseIdentifier: viewType.identifier)
    }

    func dequeueReusableHeaderFooterView<T: Reusable>() -> T {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(T.identifier) matching type \(T.self).")
        }
        return headerFooter
    }
}

extension UITableViewCell: Reusable {

}

extension UICollectionReusableView: Reusable { }

extension UITableViewHeaderFooterView: Reusable { }

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self).")
        }
        return cell
    }

    func register<T: Reusable>(cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }

    func registerView<T: Reusable>(viewType: T.Type, forSupplementaryViewOfKind: String) {
        register(viewType, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: viewType.identifier)
    }

    func dequeueReusableView<T: Reusable>(ofKind: String, indexPath: IndexPath, viewType: T.Type = T.self) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: viewType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(viewType.identifier) matching type \(viewType.self).")
        }
        return view
    }
}

extension UICollectionViewCell: Reusable {

}

