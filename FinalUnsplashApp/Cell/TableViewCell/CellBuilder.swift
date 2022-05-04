//
//  CellBuilder.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 29.04.2022.
//

import Foundation

protocol CellBuilder {
    var configurableCells: [CellConfigurator] {
        get set
    }
    
    mutating func reset() -> Self
    
    func getConfigurableCells() -> [CellConfigurator]
}

extension CellBuilder {
    mutating func reset() -> Self {
        configurableCells = []
        return self
    }
    
    func getConfigurableCells() -> [CellConfigurator] {
        return configurableCells
    }
}

