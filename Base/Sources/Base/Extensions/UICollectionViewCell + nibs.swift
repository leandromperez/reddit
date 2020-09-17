//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/17/20.
//

import Foundation
import UIKit

extension UICollectionViewCell : Bundleable {}

extension UICollectionView {
    public func cell<Cell : UICollectionViewCell > (at indexPath: IndexPath) -> Cell {

        guard let cell = self.dequeueReusableCell(withReuseIdentifier:Cell.identifier, for: indexPath) as? Cell else {fatalError()}

        return cell
    }

    public func cell<Cell : UICollectionViewCell>(at row: Int, section:Int = 0) -> Cell {
        let indexPath = IndexPath(row: row, section: section)
        return cell(at: indexPath)
    }
}

extension UICollectionViewCell {

    static public func registerNib(on collectionView:UICollectionView, bundle: Bundle? = nil) {

        let nib = self.nib(bundle: bundle)

        collectionView.register(nib, forCellWithReuseIdentifier: self.identifier)
    }

    static public func register(on collectionView:UICollectionView, bundle: Bundle? = nil) {
        collectionView.register(Self.self, forCellWithReuseIdentifier: self.identifier)
    }
}
