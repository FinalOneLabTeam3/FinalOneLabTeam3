//
//  ConfigureCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 28.04.2022.
//

import Foundation

protocol ConfigurableCell {
    associatedtype DataType
    static var reuseIdentifier: String { get }
    func configureCell(data: DataType)
}

extension ConfigurableCell {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}
