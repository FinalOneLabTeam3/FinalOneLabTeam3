//
//  UserCellBuilder.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 29.04.2022.
//

import Foundation

class UserCellBuilder: CellBuilder {
    
    var configurableCells: [CellConfigurator] = []
    
    @discardableResult
    func setUserCell(with user: UnsplashUser) -> Self {
        configurableCells.append(UserCellConfigurator(item: user))
        return self
    }
    
    @discardableResult
    func buildCells(with users: [UnsplashUser]) -> Self {
        for user in users {
            setUserCell(with: user)
        }
        return self
    }
}

