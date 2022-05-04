//
//  CellAction.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 29.04.2022.
//

import UIKit

enum CellAction: Hashable {
    case didSelect
    case willDisplay
    case custom(String)
    
    var hashValue: Int {
        switch self {
        case .didSelect: return 0
        case .willDisplay: return 1
        case .custom(let custom):
            return custom.hashValue
        }
    }
}

struct CellActionEventData {
    let action: CellAction
    let cell: UIView
}

extension CellAction {
    static let notificationName = NSNotification.Name("cellAction")
    
    func invoke(cell: UIView) {
        NotificationCenter.default.post(name: CellAction.notificationName, object: nil, userInfo: ["data": CellActionEventData(action: self, cell: cell)])
    }
}
