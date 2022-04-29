//
//  CellConfigurator.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 28.04.2022.
//

import Foundation
import UIKit

protocol CellConfigurator {
    static var reuseId: String { get }
    static var cellClass: AnyClass { get }
    func configureCell(cell: UIView)
}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {
    
    static var reuseId: String { return CellType.reuseIdentifier }
    static var cellClass: AnyClass { return CellType.self }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configureCell(cell: UIView) {
        (cell as! CellType).configureCell(data: item)
    }
    
}

